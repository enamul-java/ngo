

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import '../../../../core/config/oauth_config.dart';
import '../../domian/entity/oauth_session.dart';
import '../model/auth_user_profile.dart';

class KeycloakAuthDataSource {

  KeycloakAuthDataSource(this._appAuth);

  final FlutterAppAuth _appAuth;
  final _dio = Dio();

  Future<OAuthSession?> login() async {
    final result = await _appAuth
        .authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        OAuthConfig.clientId,
        OAuthConfig.redirectUri,
        issuer: OAuthConfig.issuer,
        scopes: OAuthConfig.scopes,
        // PKCE is handled by the native AppAuth library.
        allowInsecureConnections: true,
      ),
    );

    if (result?.accessToken == null) {
      return null;
    }

    final userProfile = await getUserProfile(result!.accessToken!);

    return OAuthSession(
      accessToken: result!.accessToken!,
      refreshToken: result.refreshToken,
      idToken: result.idToken,
      expiresAt: result.accessTokenExpirationDateTime,
      userProfile: userProfile
    );
  }

  Future<AuthUserProfile> getUserProfile(String accessToken) async {
    debugPrint("token: $accessToken");
    // Fetch the authenticated user's profile.
    final response = await _dio.get<Map<String, dynamic>>(
      '${OAuthConfig.issuer}/protocol/openid-connect/userinfo',
      options: Options(
        headers: {'Authorization': 'Bearer ${accessToken}'},
      ),
    );

    final responseData = response.data;
    if (responseData != null) {
      //throw Exception('Unable to retrieve user profile.');
      debugPrint('User Profile: $responseData');
    }
    //Checking Resource Server
    await checkResourceServer(accessToken);

    return responseData!=null? AuthUserProfile.fromJson(responseData)
      : AuthUserProfile(id: '', username: '', email: '', firstName: '', lastName: '', fullName: '');
  }

  Future<void> checkResourceServer(String accessToken) async{
    try {
      final response = await Dio().get<Map<String, dynamic>>(
        '${OAuthConfig.apiBaseUrl}/api/user/test',
        options: Options(
          headers: {'Authorization': 'Bearer ${accessToken}'},
        ),
      );
      final responseData = response.data;
      if (responseData != null) {
        debugPrint('Resource Server Response: $responseData');
      }
    }catch(e){
      debugPrint('Resource Server Response Error: ${e.toString()}');
    }
  }

  Future<OAuthSession?> refresh(OAuthSession current) async {
    final refreshToken = current.refreshToken;

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final result = await _appAuth.token(
      TokenRequest(
        OAuthConfig.clientId,
        OAuthConfig.redirectUri,
        issuer: OAuthConfig.issuer,
        refreshToken: refreshToken,
        scopes: OAuthConfig.scopes,
        allowInsecureConnections: true,
      ),
    );

    if (result?.accessToken == null) {
      return null;
    }

    final userProfile = await getUserProfile(result!.accessToken!);

    return OAuthSession(
      accessToken: result!.accessToken!,
      // Some providers omit refresh_token when it is unchanged.
      refreshToken: result.refreshToken ?? refreshToken,
      idToken: result.idToken ?? current.idToken,
      expiresAt: result.accessTokenExpirationDateTime,
      userProfile: userProfile
    );
  }

  Future<void> logout(OAuthSession? session) async {
    if (session?.idToken == null) return;

    await _appAuth.endSession(
      EndSessionRequest(
        idTokenHint: session!.idToken,
        postLogoutRedirectUrl:
        OAuthConfig.postLogoutRedirectUri,
        issuer: OAuthConfig.issuer,
        allowInsecureConnections: true,
      ),
    );
  }
}