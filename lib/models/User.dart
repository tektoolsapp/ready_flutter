class User {
  
  int id = 0;
  String name;
  String email;

  User({ this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['emp_id'],
      name: json['first_name'],
      email: json['emp_email'],
    );
  } 
}