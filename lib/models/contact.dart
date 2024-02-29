const String tableContact = 'tbl_contact';
const String tblContactColId = 'id';
const String tblContactColName = 'name';
const String tblContactColMobile = 'mobile';
const String tblContactColEmail = 'email';
const String tblContactColAddress = 'address';
const String tblContactColWebsite = 'website';
const String tblContactColImage = 'image';
const String tblContactColFavorite = 'favorite';
const String tblContactColCompany = 'company';
const String tblContactColDesignation = 'designation';

class Contact {
  int id;
  String name;
  String mobile;
  String email;
  String company;
  String designation;
  String address;
  String website;
  bool favorite;
  String image;

  Contact({
    this.id = -1,
    required this.name,
    required this.mobile,
    required this.email,
    this.company = '',
    this.designation = '',
    this.address = '',
    this.website = '',
    this.favorite = false,
    this.image = 'images/person.png',
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblContactColName : name,
      tblContactColMobile : mobile,
      tblContactColEmail : email,
      tblContactColCompany : company,
      tblContactColDesignation: designation,
      tblContactColAddress : address,
      tblContactColWebsite : website,
      tblContactColImage : image,
      tblContactColFavorite : favorite ? 1 : 0,
    };
    if(id > 0) {
      map[tblContactColId] = id;
    }
    return map;
  }

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
    id: map[tblContactColId],
    name: map[tblContactColName],
    email: map[tblContactColEmail],
    mobile: map[tblContactColMobile],
    address: map[tblContactColAddress],
    company: map[tblContactColCompany],
    designation: map[tblContactColDesignation],
    website: map[tblContactColWebsite],
    image: map[tblContactColImage],
    favorite: map[tblContactColFavorite] == 1 ? true : false,
  );

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, mobile: $mobile, email: $email, company: $company, designation: $designation, address: $address, website: $website, favorite: $favorite, image: $image}';
  }
}