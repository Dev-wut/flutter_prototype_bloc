part of 'pdf_cubit.dart';

abstract class PdfState {}

class PdfInitial extends PdfState {}

class PdfLoaded extends PdfState {
  final Map<int, bool> selectedPdfs;

  PdfLoaded({required this.selectedPdfs});

  PdfLoaded copyWith({Map<int, bool>? selectedPdfs}) {
    return PdfLoaded(
      selectedPdfs: selectedPdfs ?? this.selectedPdfs,
    );
  }

  List<int> get selectedIndexes =>
      selectedPdfs.entries.where((e) => e.value).map((e) => e.key).toList();
}
