class PostResult {
  String idUser;
  String nik;
  String username;
  String idRole;
  String idsite;
  String idposition;

  PostResult(
      {required this.idUser,
      required this.nik,
      required this.username,
      required this.idRole,
      required this.idsite,
      required this.idposition});

  //membuat object dari jsonobject
  factory PostResult.createPostResult(Map<String, dynamic> object) {
    return PostResult(
        idUser: object['id'].toString(),
        nik: object['nik'] == null ? '0' : object['nik'].toString(),
        username: object['username'],
        idRole: object['id_role'].toString(),
        idsite: object['id_site'].toString(),
        idposition: object['id_position'].toString());
  }
}
