class ResponseCodeConstant {
  /// 会话过期码（与后端自定义业务码对应，非标准 HTTP 状态码）
  static const int SESSION_EXPIRE_CODE = 100001;
  static const String SESSION_EXPIRE_MESSAGE = "登录已失效";
}
