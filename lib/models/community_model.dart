class Community{
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> members;
  final List<String> mods;

  Community({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.mods,
});

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List <String>? members,
    List <String>? mods,
}){
    return Community(
        id: id ?? this.id,
        name: name ?? this.name,
        banner: banner ?? this.banner,
        avatar: avatar ?? this.avatar,
        members: members ?? this.members,
        mods: mods ?? this.mods
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'name':name,
      'banner':banner,
      'avatar':avatar,
      'members':members,
      'mods':mods
    };
  }

  factory Community.fromJson(Map<String,dynamic> map){
    return Community(
        id: map['id']??'',
        name: map['name']??'',
        banner: map['banner']??'',
        avatar: map['avatar']??'',
        members: List<String>.from(map['members']),
        mods: List<String>.from(map['mods']),
    );
  }
}