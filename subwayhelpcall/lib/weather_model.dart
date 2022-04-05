class Weather {
  final String name;
  final num temp; //현재 온도
  final num feeltemp; //체감 온도
  final int tempMin; //최저 온도
  final int tempMax; //최고 온도
  final int humidity; //습도
  final String weatherMain; //흐림정도
  final int code; //흐림정도의 id(icon 작업시 필요)

  Weather({
    this.name,
    this.temp,
    this.feeltemp,
    this.tempMin,
    this.tempMax,
    this.humidity,
    this.weatherMain,
    this.code,
  });
}
