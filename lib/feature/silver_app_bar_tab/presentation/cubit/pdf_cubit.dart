import 'package:flutter_bloc/flutter_bloc.dart';

part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  final List<String> pdfTitles = [
    'Adobe Sample Explain',
    'Acrobat Reference Guide',
    'W3C Dummy PDF Test',
    'PDF Object Sample',
    'Q4 Test Document',
    'Smallpdf Sample',
    'Mozilla Test PDF',
    'Learning Container Sample'
  ];

  final List<String> pdfPaths = [
    // URL 1 - Adobe Sample
    'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
    // URL 2 - Acrobat Reference
    'https://helpx.adobe.com/pdf/acrobat_reference.pdf',
    // URL 3 - W3C Dummy
    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    // URL 4 - PDF Object
    'https://pdfobject.com/pdf/sample.pdf',
    // URL 5 - Q4 Test Document
    'https://s24.q4cdn.com/216390268/files/doc_downloads/test.pdf',
    // URL 6 - File Examples Sample
    'https://file-examples.com/storage/fe5f8b3b1b634b21b32d65e/2017/10/file_example_PDF_500_kB.pdf',
    // URL 7 - Learning Container Sample
    'https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-file.pdf',
    // URL 8 - AWS Sample
    'https://conasems-ava-prod.s3.sa-east-1.amazonaws.com/aulas/ava/dummy-1641923583.pdf',
  ];

  PdfCubit() : super(PdfInitial()) {
    emit(PdfLoaded(selectedPdfs: {}));
  }

  void togglePdf(int index) {
    if (state is PdfLoaded) {
      final currentState = state as PdfLoaded;
      final updatedSelected = Map<int, bool>.from(currentState.selectedPdfs);

      updatedSelected[index] = !(updatedSelected[index] ?? false);

      emit(currentState.copyWith(selectedPdfs: updatedSelected));
    }
  }

  void clearAll() {
    emit(PdfLoaded(selectedPdfs: {}));
  }

  void selectAll() {
    final allSelected = <int, bool>{};
    for (int i = 0; i < 8; i++) {  // เปลี่ยนเป็น 8
      allSelected[i] = true;
    }
    emit(PdfLoaded(selectedPdfs: allSelected));
  }
}