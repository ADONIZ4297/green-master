class TerrarariumData {
  int temperature;
  int humidity;
  String lampStart;
  String lampEnd;
  bool lampAuto;
  bool lampOn;
  String vaporizerPeriod;
  String vaporizerTime;
  bool vaporizerAuto;
  bool vaporizerOn;

  TerrarariumData({
    this.temperature = 0000,
    this.humidity = 0000,
    this.lampStart = "0000",
    this.lampEnd = "0000",
    this.lampOn = false,
    this.lampAuto = false,
    this.vaporizerAuto = false,
    this.vaporizerOn = false,
    this.vaporizerPeriod = "0000",
    this.vaporizerTime = "0000",
  });
}
