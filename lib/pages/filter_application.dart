import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class FilterApplication extends StatefulWidget {
  final String docID;

  const FilterApplication({Key? key, required this.docID}) : super(key: key);

  @override
  FilterApplicationState createState() => FilterApplicationState(docID: docID);
}

class FilterApplicationState extends State<FilterApplication> {
  String docID;
  int selectedOptionIndex = 0;

  FilterApplicationState({Key? key, required this.docID});

  Country selectedCountry = Country(
      phoneCode: "92",
      countryCode: "KO",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Select your Country",
      example: "Pakistan",
      displayName: "Pakistan",
      displayNameNoCountryCode: "PAK",
      e164Key: "");

  String selectedcountry = "Pakistan";

  double _sliderValue = 50;

  String selectedGender = 'Any';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset("assets/icons/img_4.png", width: 30, height: 30,),
            onPressed: () {
              // Add your bell icon functionality here
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/boardB.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 12,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Filters',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 97,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF707070)),
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Select Location',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Container(
                        //width: 120,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: (){
                              showCountryPicker(
                                  context: context,
                                  countryListTheme: const CountryListThemeData(
                                      bottomSheetHeight: 450
                                  ),
                                  onSelect: (value){
                                    setState(() {
                                      selectedCountry=value;
                                    });
                                  });
                            },
                            child: Row(
                              children: [
                                const Expanded(child: SizedBox(width: 10)),
                                Text(
                                  "${selectedCountry.flagEmoji} ${selectedCountry.name}",
                                  style: selectedCountry.name == "Select your Country"
                                      ? TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400, // Change color to grey
                                    fontWeight: FontWeight.w600,
                                  )
                                      : const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Expanded(child: SizedBox(width: 10)),
                                Image.asset("assets/icons/img.png", width: 20, height: 20),
                                const SizedBox(width: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18,),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 97,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF707070)),
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Choose Age',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Slider(
                        value: _sliderValue,
                        min: 18,
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                        activeColor: Colors.pink,
                        inactiveColor: Colors.grey,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_sliderValue.toInt()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18,),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 97,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF707070)),
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Looking For',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                      SizedBox(
                        height: 30,
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGender = 'Any';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                      color: selectedGender == 'Any' ? Colors.pink : Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Any',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        Image.asset("assets/icons/img_8.png", width: 30, fit: BoxFit.fitWidth),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGender = 'Male';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 1),
                                      color: selectedGender == 'Male' ? Colors.pink : Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Male',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        Image.asset("assets/icons/img_9.png", width: 30, fit: BoxFit.fitWidth),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGender = 'Female';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 1),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                      color: selectedGender == 'Female' ? Colors.pink : Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Female',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        Image.asset("assets/icons/img_10.png", width: 30, fit: BoxFit.fitWidth),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18,),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 97,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF707070)),
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Profession',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              // Replace this onTap function with your text field logic.
                            },
                            child: const Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18,),
              Image.asset("assets/icons/img_7.png", height: 30, fit: BoxFit.fitHeight,),
              //const Expanded(child: SizedBox(height: 10,)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF337C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        height: 50,
        child: const Center(
          // Your content here
        ),
      ),
    );
  }
}
