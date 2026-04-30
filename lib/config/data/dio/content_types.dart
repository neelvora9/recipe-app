

enum CType {
  json('application/json'),
  xml('application/xml'),
  formUrlEncoded('application/x-www-form-urlencoded'),
  formData('multipart/form-data'),
  textPlain('text/plain'),
  textHtml('text/html'),
  octetStream('application/octet-stream'),
  applicationPdf('application/pdf'),
  imageJpeg('image/jpeg'),
  imagePng('image/png'),
  audioMpeg('audio/mpeg'),
  videoMp4('video/mp4'),
  zip('application/zip'),
  rar('application/vnd.rar');

  final String value;

  const CType(this.value);
}
