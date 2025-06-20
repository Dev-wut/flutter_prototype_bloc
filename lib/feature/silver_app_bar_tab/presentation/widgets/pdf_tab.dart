// pdf_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../cubit/pdf_cubit.dart';

class PdfTab extends StatelessWidget {
  final int tabIndex;
  final String title;
  final bool isLoaded;

  const PdfTab({
    super.key,
    required this.tabIndex,
    required this.title,
    required this.isLoaded,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create: (context) => PdfCubit(),
      child: _PdfTabContent(title: title),
    );
  }
}

class _PdfTabContent extends StatefulWidget {
  final String title;

  const _PdfTabContent({required this.title});

  @override
  State<_PdfTabContent> createState() => _PdfTabContentState();
}

class _PdfTabContentState extends State<_PdfTabContent> with AutomaticKeepAliveClientMixin {
  final Map<int, PDFViewController?> _pdfControllers = {};
  final Map<int, bool> _pdfLoading = {};
  final Map<int, String?> _pdfErrors = {};
  final Map<int, String?> _localPdfPaths = {}; // Store downloaded file paths

  @override
  bool get wantKeepAlive => true; // Keep state when switching tabs

  @override
  void dispose() {
    // Clean up all resources
    _clearAllControllers();
    _cleanupCacheFiles();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return BlocBuilder<PdfCubit, PdfState>(
      builder: (context, state) {
        if (state is! PdfLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final cubit = context.read<PdfCubit>();
        final selectedIndexes = state.selectedIndexes;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header with checkboxes และ performance controls
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: cubit.selectAll,
                              child: const Text('Select All'),
                            ),
                            TextButton(
                              onPressed: () {
                                cubit.clearAll();
                                _clearAllControllers();
                              },
                              child: const Text('Clear All'),
                            ),
                            // เพิ่ม Clear Cache button
                            TextButton(
                              onPressed: _clearCache,
                              child: const Text('Clear Cache'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Checkboxes
                    Wrap(
                      children: List.generate(8, (index) {  // เปลี่ยนเป็น 8
                        final isSelected = state.selectedPdfs[index] ?? false;
                        return Container(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (value) {
                              if (!isSelected) {
                                // Selecting PDF - start download
                                _downloadAndLoadPdf(index, cubit);
                                cubit.togglePdf(index);
                              } else {
                                // Deselecting PDF - dispose controller
                                _disposePdfController(index);
                                cubit.togglePdf(index);
                              }
                            },
                            title: Text(
                              cubit.pdfTitles[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              // PDF Views
              Expanded(
                child: selectedIndexes.isEmpty
                    ? const Center(
                  child: Text(
                    'Select PDFs to view',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : _buildPdfViews(selectedIndexes, cubit),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPdfViews(List<int> selectedIndexes, PdfCubit cubit) {
    if (selectedIndexes.length == 1) {
      // Single PDF - Full screen
      return _buildSinglePdfView(selectedIndexes.first, cubit);
    } else {
      // Multiple PDFs - Grid layout (2 per row)
      return _buildGridPdfViews(selectedIndexes, cubit);
    }
  }

  Widget _buildSinglePdfView(int index, PdfCubit cubit) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    cubit.pdfTitles[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _disposePdfController(index);
                    cubit.togglePdf(index);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildPdfViewWidget(index, cubit),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPdfViews(List<int> selectedIndexes, PdfCubit cubit) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: selectedIndexes.length,
      itemBuilder: (context, gridIndex) {
        final pdfIndex = selectedIndexes[gridIndex];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cubit.pdfTitles[pdfIndex],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        _disposePdfController(pdfIndex);
                        cubit.togglePdf(pdfIndex);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildPdfViewWidget(pdfIndex, cubit),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPdfViewWidget(int index, PdfCubit cubit) {
    final localPath = _localPdfPaths[index];
    final isLoading = _pdfLoading[index] ?? false;
    final error = _pdfErrors[index];

    if (error != null) {
      return Container(
        color: Colors.red[50],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              const Text('Failed to load PDF'),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _downloadAndLoadPdf(index, cubit),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoading || localPath == null) {
      return Container(
        color: Colors.white.withOpacity(0.8),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Downloading PDF...'),
            ],
          ),
        ),
      );
    }

    return PDFView(
      filePath: localPath,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      pageSnap: true,
      pageFling: false,
      onViewCreated: (PDFViewController controller) {
        setState(() {
          _pdfControllers[index] = controller;
        });
      },
      onRender: (pages) {
        print('PDF $index rendered with $pages pages');
      },
      onError: (error) {
        setState(() {
          _pdfErrors[index] = error.toString();
          _pdfLoading[index] = false;
        });
      },
      onPageError: (page, error) {
        setState(() {
          _pdfErrors[index] = 'Page $page: $error';
          _pdfLoading[index] = false;
        });
      },
      onPageChanged: (page, total) {
        // Optional: Handle page changes
      },
    );
  }

  Future<void> _downloadAndLoadPdf(int index, PdfCubit cubit) async {
    setState(() {
      _pdfLoading[index] = true;
      _pdfErrors.remove(index);
    });

    try {
      final url = cubit.pdfPaths[index];
      final fileName = 'pdf_${widget.title}_$index.pdf'; // Include tab title for uniqueness

      // Get application documents directory
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');

      // Check if file already exists และเช็คขนาดไฟล์
      if (await file.exists()) {
        final fileSize = await file.length();
        if (fileSize > 0) { // Make sure file is not corrupted
          setState(() {
            _localPdfPaths[index] = file.path;
            _pdfLoading[index] = false;
          });
          return;
        } else {
          // Delete corrupted file
          await file.delete();
        }
      }

      // Download PDF with timeout
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Download timeout');
        },
      );

      if (response.statusCode == 200) {
        // Check if response has content
        if (response.bodyBytes.isEmpty) {
          throw Exception('Downloaded file is empty');
        }

        await file.writeAsBytes(response.bodyBytes);

        // Verify file was written correctly
        final fileSize = await file.length();
        if (fileSize == 0) {
          throw Exception('Failed to save PDF file');
        }

        setState(() {
          _localPdfPaths[index] = file.path;
          _pdfLoading[index] = false;
        });
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _pdfErrors[index] = e.toString();
        _pdfLoading[index] = false;
      });
    }
  }

  // Clear cache manually
  Future<void> _clearCache() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final tabTitle = widget.title.replaceAll(' ', '_');

      for (int i = 0; i < 8; i++) {  // เปลี่ยนเป็น 8
        final file = File('${dir.path}/pdf_${tabTitle}_$i.pdf');
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Clear local paths
      setState(() {
        _localPdfPaths.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing cache: $e')),
      );
    }
  }

  // Get cache size for display
  Future<String> _getCacheSize() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      int totalSize = 0;

      for (int i = 0; i < 8; i++) {  // เปลี่ยนเป็น 8
        final file = File('${dir.path}/pdf_${widget.title}_$i.pdf');
        if (await file.exists()) {
          totalSize += await file.length();
        }
      }

      if (totalSize == 0) return '0 MB';
      return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (e) {
      return 'Unknown';
    }
  }

  void _disposePdfController(int index) {
    // PDFViewController ไม่มี dispose method
    // แค่ remove reference และ cleanup memory
    setState(() {
      _pdfControllers.remove(index);
      _pdfLoading.remove(index);
      _pdfErrors.remove(index);
      _localPdfPaths.remove(index);
    });

    // Force garbage collection hint
    if (_pdfControllers.isEmpty) {
      // All PDFs are closed, suggest garbage collection
      print('All PDFs closed, memory should be freed');
    }
  }

  void _clearAllControllers() {
    // Clear all references และ suggest garbage collection
    setState(() {
      _pdfControllers.clear();
      _pdfLoading.clear();
      _pdfErrors.clear();
      _localPdfPaths.clear();
    });

    // Suggest garbage collection when clearing all
    print('All PDF controllers cleared, suggesting memory cleanup');
  }

  // Clean up cache files when widget is disposed หรือเมื่อต้องการ
  Future<void> _cleanupCacheFiles() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final tabTitle = widget.title.replaceAll(' ', '_');

      for (int i = 0; i < 8; i++) {  // เปลี่ยนเป็น 8
        final file = File('${dir.path}/pdf_${tabTitle}_$i.pdf');
        if (await file.exists()) {
          await file.delete();
        }
      }
      print('Cache files cleaned up for ${widget.title}');
    } catch (e) {
      print('Error cleaning cache: $e');
    }
  }
}