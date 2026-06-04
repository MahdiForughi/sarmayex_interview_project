import 'package:flutter_test/flutter_test.dart';
import 'package:sarmayex_interview_project/app/constants/base_urls.dart';
import 'package:sarmayex_interview_project/app/network/http_sse_client.dart';

void main() {
  test('Test SSE Connection returns 200', () async {
    final client = HttpSseClient();
    await client.connect(BaseUrls.subscribeMarketUrl('USDT_IRT'));

    expect(client.isConnected, true);

    client.disconnect();
  });
}
