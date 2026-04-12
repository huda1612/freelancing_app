class PostType {
  final String type;
  const PostType._(this.type);
  static const add = PostType._("add");
  static const update = PostType._("update");
  static const delete = PostType._("delete");
  // static const login = PostType._("login");
  // static const signUp = PostType._("signUp");
}
