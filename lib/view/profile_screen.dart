import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/constants/c_colors.dart';
import 'package:flutter_task/constants/c_strings.dart';
import 'package:flutter_task/resources/text_styles.dart';
import 'package:flutter_task/utils/display_utils.dart';

import '../modals/res/profile_res.dart';
import '../modals/services/api_endpoint.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileRes ?_profileRes;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: cPinkColor,
          centerTitle: true,
          title: Text(CStrings.profile),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return dataFromProfileApi();
          },
          child: Center(
              child: _profileRes == null
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            dragDataText(),
                            _profileData(_profileRes),
                            vGap(20),
                          ]),
                    )),
        ));
  }

  Widget dragDataText() {
    return Text(
      CStrings.dragTheScreen,
      style: TextStyle(
          color: Colors.red,
          fontSize: 14), 
    );
  }

  Widget _profileData(ProfileRes? profileRes) {
    return Expanded(
      child: profileRes?.results?.length == 0
          ? Center(
              child: Text(
              "No data found",
              style: TextStyles.getSubTital20(),
            ))
          : ListView.builder(
              itemCount: profileRes?.results?.length ?? 0,
              itemBuilder: (context, index) {
                final resData = profileRes!.results![index];
                final dob = DateTime.parse(resData.dob!.date!);
                final registeredDate =
                    DateTime.parse(resData.registered!.date!);
                final daysPassed =
                    DateTime.now().difference(registeredDate).inDays;

                return Card(
                  color: CWhiteColor,
                  shadowColor: cBlackColor,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl: resData.picture?.large ?? "",
                            imageBuilder: (context, imageProvider) {
                              // ignore: unnecessary_null_comparison
                              if (imageProvider != null) {
                                return Image(image: imageProvider);
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                        vGap(10),
                        Text(
                          CStrings.name +
                              " ${resData.name!.title} ${resData.name!.first} ${resData.name!.last}",
                          style: TextStyles.getSubTital18(),
                        ),
                        Text(
                          CStrings.location +
                              " ${resData.location!.street!.number} ${resData.location!.street!.name}, ${resData.location!.city}, ${resData.location!.state}, ${resData.location!.country}, ${resData.location!.postcode}",
                          style: TextStyles.getSubTital18(),
                        ),
                        Text(
                          CStrings.email + " ${resData.email}",
                          style: TextStyles.getSubTital18(),
                        ),
                        Text(
                          CStrings.dob + " ${dob.day}/${dob.month}/${dob.year}",
                          style: TextStyles.getSubTital18(),
                        ),
                        Text(
                          CStrings.noOfDays + " $daysPassed",
                          style: TextStyles.getSubTital18(),
                        ),
                        vGap(10),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
@override
void initState() {
  dataFromProfileApi();
  super.initState();
  
}
  //profile api
  dataFromProfileApi() async {
    try {
      Response profileResponce = await Dio().get(
        ApiEndPoint.profileApi,
      );
      final profileResult = ProfileRes.fromJson(profileResponce.data);
      setState(() {
              _profileRes = profileResult;

      });
    
    } on DioException catch (e) {
      print(e);
    }
  }
}
