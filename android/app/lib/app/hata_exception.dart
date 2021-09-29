class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'Bu email adresi zaten kullanımda, lütfen başka bir email ile '
            'giriş yapınız';

      case 'ERROR_USER_NOT_FOUND':
        return 'Bu kullanıcı sistemde bulunmamaktadır';

      default:
        return 'Bir hata oluştu!';
    }
  }
}
