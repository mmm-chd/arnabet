class LoginErrorMapper {
  static String map(Object error) {
    return _mapErrorMessage(error);
  }

  static String _mapErrorMessage(Object error) {
    final raw = error.toString().replaceAll('Exception: ', '');

    if (raw.contains('DioException') ||
        raw.contains('connectionError') ||
        raw.contains('SocketException') ||
        raw.contains('Tidak ada koneksi internet') ||
        raw.contains('Network is unreachable') ||
        raw.contains('Connection refused')) {
      return 'Tidak ada koneksi internet. Periksa jaringan Anda dan coba lagi.';
    }

    if (raw.contains('Waktu koneksi habis') ||
        raw.contains('TimeoutException') ||
        raw.contains('timed out')) {
      return 'Koneksi timeout. Server tidak merespons, coba beberapa saat lagi.';
    }

    if (raw.contains('HandshakeException') ||
        raw.contains('CERTIFICATE') ||
        raw.contains('SSL')) {
      return 'Koneksi tidak aman. Periksa tanggal & waktu perangkat Anda.';
    }

    if (raw.contains('Connection reset') || raw.contains('Connection closed')) {
      return 'Koneksi terputus. Silakan coba lagi.';
    }

    if (raw.contains('500') || raw.contains('Internal Server Error')) {
      return 'Terjadi kesalahan pada server. Silakan coba beberapa saat lagi.';
    }

    if (raw.contains('503') || raw.contains('Service Unavailable')) {
      return 'Server sedang dalam pemeliharaan. Silakan coba beberapa saat lagi.';
    }

    if (raw.contains('502') || raw.contains('Bad Gateway')) {
      return 'Server tidak dapat dijangkau. Silakan coba beberapa saat lagi.';
    }

    if (raw.contains('401') ||
        raw.contains('Unauthorized') ||
        raw.contains('Login gagal')) {
      return 'Email atau password salah. Silakan periksa kembali.';
    }

    if (raw.contains('403') || raw.contains('Forbidden')) {
      return 'Akun Anda tidak memiliki akses. Hubungi administrator.';
    }

    if (raw.contains('404') || raw.contains('Not Found')) {
      return 'Akun tidak ditemukan. Periksa kembali email Anda.';
    }

    if (raw.contains('429') || raw.contains('Too Many Requests')) {
      return 'Terlalu banyak percobaan login. Silakan tunggu beberapa menit.';
    }

    if (raw.contains('422') || raw.contains('Unprocessable')) {
      return 'Data yang dikirim tidak valid. Periksa kembali email dan password.';
    }

    if (raw.contains('Role tidak dikenali') ||
        raw.contains('Role tidak valid')) {
      return 'Akun Anda belum memiliki peran yang valid. Hubungi administrator.';
    }

    if (raw.contains('account') && raw.contains('disabled') ||
        raw.contains('akun') && raw.contains('dinonaktifkan')) {
      return 'Akun Anda telah dinonaktifkan. Hubungi administrator.';
    }

    if (raw.contains('account') && raw.contains('locked') ||
        raw.contains('akun') && raw.contains('dikunci')) {
      return 'Akun Anda dikunci karena terlalu banyak percobaan. Hubungi administrator.';
    }

    if (raw.contains('FormatException') || raw.contains('SyntaxError')) {
      return 'Terjadi kesalahan membaca data server. Silakan coba lagi.';
    }

    if (raw.contains('Null check operator') || raw.contains('Null')) {
      return 'Terjadi kesalahan tidak terduga. Silakan coba lagi.';
    }

    if (raw.isNotEmpty) return raw;
    return 'Terjadi kesalahan tidak diketahui. Silakan coba lagi.';
  }
}
