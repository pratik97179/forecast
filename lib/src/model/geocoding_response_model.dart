class GeocodingResponseModel {
  String type;
  List<String> query;
  List<Features> features;
  String attribution;

  GeocodingResponseModel(
      {this.type, this.query, this.features, this.attribution});

  GeocodingResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    query = json['query'].cast<String>();
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['query'] = this.query;
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    data['attribution'] = this.attribution;
    return data;
  }
}

class Features {
  List<double> center;

  Features({
    this.center,
  });

  Features.fromJson(Map<String, dynamic> json) {
    center = json['center'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['center'] = this.center;
    return data;
  }
}