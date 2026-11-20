
import '../../../features/oauth/domian/repository/oauth_repository.dart';
import 'api_token_provider.dart';

class RepositoryApiTokenProvider implements ApiTokenProvider {

  RepositoryApiTokenProvider(this._repository);

  final OAuthRepository _repository;

  @override
  Future<String?> getAccessToken() async {
    final session = await _repository.restoreSession();
    return session?.accessToken;
  }

  @override
  Future<String?> refreshAccessToken() async {
    final session = await _repository.refreshSession();
    return session?.accessToken;
  }
}