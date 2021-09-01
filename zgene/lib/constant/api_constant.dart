///api路径
class ApiConstant {
  static const String BASE_API = "http://zgene.divms.com";

  ///********************************** 自媒体流 *****************************///
  //获取所有分类
  static const String categoriesList = "/api/v1/categories";
  //内容列表
  static const String contentList = "/api/v1/archives";
  //内容详情
  static const String contentDetail = "/api/v1/archive/:aid";
  //内容点赞
  static const String contentGood = "/api/v1/digg/archive/:aid";
  //评论点赞
  static const String commentGood = "/api/v1/digg/:aid/comment/:cid";
  //收藏内容
  static const String contentCollection = "/api/v1/favor/archive/:aid";
  //收藏列表
  static const String myCollectionList = "/api/v1/user/favorites";
  //获取一级评论
  static const String firstCommentList = "/api/v1/archive/:aid/comments";
  //获取二级评论
  static const String secondCommentList = "/api/v1/comment/:cid";
  //添加评论
  static const String addComment = "/api/v1/comment";
  //获取评论记录
  static const String myCommentList = "/api/v1/user/comments";
  //获取点赞记录
  static const String myGoodList = "/api/v1/user/diggs";
  //根据标签获取列表
  static const String tagGetList = "/api/v1/tag/:tid/archives";
  //收藏列表
  static const String favoritesRecordList = "/api/v1/user/favorites";
  //点赞列表
  static const String goodRecordList = "/api/v1/user/diggs";
  //购买内容
  static const String buyContent = "/api/v1/buy/archive";
  //用户历史浏览记录
  static const String userHistoryList = "/api/v1/user/history";
  //内容里面的推荐列表
  static const String contentRecommendList = "/api/v1/archive/:aid/recommends";
  //购买记录
  static const String buyRecordList = "/api/v1/user/purchased";

  ///********************************* 消息 *****************************///
  //未读消息数量
  static const String noticeCount = "/api/v1/user/notice/count";
  //消息列表
  static const String messageList = "/api/v1/user/notices";
  //阅读全部消息
  static const String readMessage = "/api/v1/user/notice/readall";

  ///********************************* 用户 *****************************///
  //获取用户详情、修改用户信息
  static const String userInfo = "/api/v1/user/info";
  //消费记录
  static const String coinOrders = "/api/v1/coin/orders";
  //消费记录
  static const String payOrders = "/api/v1/pay/orders";
  //隐私政策
  static const String privacy = "/privacy";
  //用户隐私
  static const String agreement = "/agreement";
  //用户隐私
  static const String payLink = "/service/pay/#/pages/CoinRecharge/index";
  // https://www.divms.com/service/pay/#/pages/CoinRecharge/index
  //用户头像上传
  static const String userAvatar = "/api/v1/user/avatar";

  ///********************************** 登录 *****************************///
  //注册密保问题
  static const String securityQuestion = "/api/v1/security/question";
  //获取验证码
  static const String loginSms = "/api/v1/login/sms";
  //账号密码注册
  static const String registerPwd = "/api/v1/register/pwd";
  //手机号登录
  static const String loginApp_phone = "/api/v1/user/login/app_phone";
  //账号密码登录
  static const String loginApp_pwd = "/api/v1/user/login/app_pwd";
  //密码找回验证密保
  static const String checkSq_answer = "/api/v1/check/sq_answer";
  //密码找回设置密码
  static const String pwdBy_answer = "/api/v1/reset/pwd/by_answer";
  //配置
  static const String user_unregister = "/api/v1/user/unregister";
  //配置
  static const String settings = "/api/v1/settings";
  //获取广告配置
  static const String adConfig = "/bxapi/getappadposition";

  //隐私政策
  static const String privacys = BASE_API + ApiConstant.privacy;
  //用户协议
  static const String agreements = BASE_API + ApiConstant.agreement;
  //用户协议
  static const String payLinks = BASE_API + ApiConstant.payLink;
}
