import 'package:flutter/cupertino.dart';
import 'package:survey_app/api_service/GetLocationDetailsAPI.dart';

class LocationFilterData with ChangeNotifier {
  static List<dynamic> constituencyTypeList = [];
  static List<dynamic> constituencyList = [];
  static List<dynamic> stateList = [];
  static List<dynamic> districtList = [];
  static List<dynamic> blockList = [];
  static List<dynamic> cityList = [];
  static List<dynamic> panchayatList = [];


  static String? selectedConstituencyType;
  static String? selectedConstituency;
  static String? selectedState;
  static String? selectedDistrict;
  static String? selectedCity;
  static String? selectedBlock;
  static String? selectedPanchayat;


  void onConstituencyTypeChanged(String? val)async{
    selectedConstituencyType = val;
    notifyListeners();
    if(selectedConstituencyType != null && selectedState != null){
      selectedConstituency = null;
      getConstituencyList(constituencyTypeId: selectedConstituencyType!, stateId: selectedState!);
    }
  }

  void onStateChanged(String? val)async{
    selectedState = val;
    notifyListeners();
    if(selectedConstituencyType != null && selectedState != null){
      selectedConstituency = null;
      getConstituencyList(constituencyTypeId: selectedConstituencyType!, stateId: selectedState!);
    }
    if(selectedState != null){
      selectedDistrict = null;
      selectedCity = null;
      selectedPanchayat = null;
      selectedBlock = null;
      getDistrictList(stateId: selectedState!);
    }

  }

  void onConstituencyChanged(String? val)async{
    selectedConstituency = val;
    notifyListeners();
  }

  void onDistrictChanged(String? val)async{
    selectedDistrict = val;
    if(selectedDistrict == null){
      return;
    }

    selectedBlock = null;
    getBlockList(districtId: selectedDistrict!);

    selectedPanchayat = null;
    getPanchayatList(districtId: selectedDistrict!);

    selectedCity = null;
    getCityList(districtId: selectedDistrict!);

    notifyListeners();
  }

  void onCityChanged(String? val)async{
    selectedCity = val;
    notifyListeners();
  }

  void onBlockChanged(String? val)async{
    selectedBlock = val;
    notifyListeners();
  }

  void onPanchayatChanged(String? val)async{
    selectedPanchayat = val;
    notifyListeners();
  }



  Future<void> getConstituencyTypeList() async {
    constituencyTypeList.clear();
    constituencyTypeList.addAll(
      await GetLocationDetailsAPI.getConstituencyTypeList(),
    );
    notifyListeners();
  }


  Future<void> getStateList() async {
    stateList.clear();
    stateList.addAll(await GetLocationDetailsAPI.getStateList());
    notifyListeners();
  }


  Future<void> getConstituencyList({
    required String constituencyTypeId,
    required String stateId,
  }) async {
    constituencyList.clear();
    constituencyList.addAll(
      await GetLocationDetailsAPI.getConstituencyList(
        constituencyTypeID: constituencyTypeId,
        stateId: stateId,
      ),
    );
    notifyListeners();
  }

  Future<void> getDistrictList({required String stateId}) async {
    districtList.clear();
    districtList.addAll(
      await GetLocationDetailsAPI.getDistrictList(stateId: stateId),
    );
    notifyListeners();
  }

  Future<void> getCityList({required String districtId}) async {
    cityList.clear();
    cityList.addAll(
      await GetLocationDetailsAPI.getCityList(districtId: districtId),
    );
    notifyListeners();
  }

  Future<void> getBlockList({required String districtId}) async {
    blockList.clear();
    blockList.addAll(
      await GetLocationDetailsAPI.getBlockList(districtId: districtId),
    );
    notifyListeners();
  }

  Future<void> getPanchayatList({required String districtId}) async {
    panchayatList.clear();
    panchayatList.addAll(
      await GetLocationDetailsAPI.getPanchayatList(districtId: districtId),
    );
    notifyListeners();
  }

  Future<void> getInitialData() async {
    getConstituencyTypeList();
    getStateList();
  }

  Future<void> notify()async{
    notifyListeners();
  }

}