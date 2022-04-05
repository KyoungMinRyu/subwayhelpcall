class Subway {
  String name;
  int key;

  Subway(
    this.name,
    this.key,
  );

  Subway.fromJson(var value) {
    this.name = value['User']['Name'];
    this.key = value['User']['DeviceNumber'];
  }
}
