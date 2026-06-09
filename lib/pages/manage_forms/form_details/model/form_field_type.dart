/// Registry of all supported form field types from the form builder.
/// Widgets are added incrementally in [FormFieldRenderer].
class FormFieldType {
  static const description = 'description';
  static const formula = 'formula';
  static const group = 'group';
  static const dropdown = 'dropdown';
  static const openEnded = 'open ended';
  static const scanner = 'scanner';
  static const location = 'location';
  static const task = 'task';
  static const rating = 'rating';
  static const imageUpload = 'image upload';
  static const fileUpload = 'file upload';
  static const phone = 'phone';
  static const number = 'number';
  static const yesNo = 'yesno';
  static const imageSelection = 'image selection';
  static const audioRecording = 'audio recording';
  static const date = 'date';
  static const signature = 'signature';
  static const videoUpload = 'video upload';
  static const numbersSlider = 'numbers slider';
  static const email = 'email';

  static const all = [
    description,
    formula,
    group,
    dropdown,
    openEnded,
    scanner,
    location,
    task,
    rating,
    imageUpload,
    fileUpload,
    phone,
    number,
    yesNo,
    imageSelection,
    audioRecording,
    date,
    signature,
    videoUpload,
    numbersSlider,
    email,
  ];
}
