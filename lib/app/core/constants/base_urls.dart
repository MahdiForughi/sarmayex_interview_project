class BaseUrls {
  static const baseUrl = 'https://core.sarmayex.com/api/v1';

  static String subscribeMarketUrl(String symbol) => '$baseUrl/markets/$symbol/subscribe';
}
