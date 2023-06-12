// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../../services/global_method.dart';
import '../../../services/utils.dart';
import '../../../view_model/user_provider.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';

class UserInfoScreen extends HookConsumerWidget {
  UserInfoScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);
    final nameTextController = useTextEditingController(text: user.name);
    final emailTextController = useTextEditingController(text: user.email);
    final zipcodeTextController = useTextEditingController(text: user.zipcode);
    final phoneNumberTextController =
        useTextEditingController(text: user.phoneNumber);
    final addressTextController = useTextEditingController(text: user.address);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        title: TextWidget(
          text: 'User Information',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Name
            _separateInfo(
              color: color,
              title: 'Name',
              userInformation: user.name,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return _textEditField(
                      title: 'Name',
                      context: context,
                      textController: nameTextController,
                      onPressed: () async {
                        try {
                          await userNotifier.updateUserName(
                            nameTextController.text,
                          );
                          Navigator.pop(context);
                          // ignore: avoid_catches_without_on_clauses
                        } catch (err) {
                          await GlobalMethods.errorDialog(
                            subtitle: err.toString(),
                            context: context,
                          );
                        }
                      },
                      textInputType: TextInputType.name,
                    );
                  },
                );
              },
            ),
            // Email
            _separateInfo(
              color: color,
              title: 'Email',
              userInformation: user.email,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return _textEditField(
                      title: 'Email',
                      context: context,
                      textController: emailTextController,
                      onPressed: () async {
                        try {
                          await userNotifier.updateUserEmail(
                            emailTextController.text,
                          );
                          Navigator.pop(context);
                          // ignore: avoid_catches_without_on_clauses
                        } catch (err) {
                          await GlobalMethods.errorDialog(
                            subtitle: err.toString(),
                            context: context,
                          );
                        }
                      },
                      textInputType: TextInputType.emailAddress,
                    );
                  },
                );
              },
            ),
            // Sex
            _separateInfo(
              color: color,
              title: 'Sex',
              userInformation: user.sex == -1
                  ? ''
                  : user.sex == 0
                      ? 'Male'
                      : 'Female',
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return _selectSex(
                      context: context,
                      userNotifier: userNotifier,
                    );
                  },
                );
              },
            ),
            // Birthday
            _separateInfo(
              color: color,
              title: 'Birthday',
              userInformation: user.birthday == ''
                  ? ''
                  : DateFormat('yyyy/M/d')
                      .format(DateTime.parse(user.birthday)),
              onPressed: () {
                DatePicker.showDatePicker(
                  context,
                  minTime: DateTime(1900),
                  maxTime: DateTime(2023, 12, 31),
                  onConfirm: (date) async {
                    final birthday = DateFormat('yyyyMMdd').format(date);
                    await userNotifier.updateUserBirthday(birthday);
                  },
                  currentTime: user.birthday == ''
                      ? DateTime(1990)
                      : DateTime.parse(user.birthday),
                );
              },
            ),
            // Country
            _selectCountry(
              context: context,
              userNotifier: userNotifier,
              userCountry: user.country,
              color: color,
            ),
            // Zipcode
            _separateInfo(
              color: color,
              title: 'Zip Code',
              userInformation: user.zipcode,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return _textEditField(
                      title: 'Zip Code',
                      context: context,
                      textController: zipcodeTextController,
                      onPressed: () async {
                        try {
                          await userNotifier.updateUserZipcode(
                            zipcodeTextController.text,
                          );
                          Navigator.pop(context);
                          // ignore: avoid_catches_without_on_clauses
                        } catch (err) {
                          await GlobalMethods.errorDialog(
                            subtitle: err.toString(),
                            context: context,
                          );
                        }
                      },
                      textInputType: TextInputType.number,
                    );
                  },
                );
              },
            ),
            // Address
            _separateInfo(
              color: color,
              title: 'Address',
              userInformation: user.address,
              onPressed: () async {
                // ignore: inference_failure_on_function_invocation
                await showDialog(
                  context: context,
                  builder: (context) {
                    return Material(
                      color: Colors.transparent,
                      child: Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: _textEditField(
                            title: 'Address',
                            context: context,
                            textController: addressTextController,
                            onPressed: () async {
                              try {
                                await userNotifier.updateUserAddress(
                                  addressTextController.text,
                                );
                                Navigator.pop(context);
                                // ignore: avoid_catches_without_on_clauses
                              } catch (err) {
                                await GlobalMethods.errorDialog(
                                  subtitle: err.toString(),
                                  context: context,
                                );
                              }
                            },
                            textInputType: TextInputType.name,
                            height: 250,
                            maxLines: 5,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // Phone Number
            _separateInfo(
              color: color,
              title: 'Phone Number',
              userInformation: user.phoneNumber,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return _textEditField(
                      title: 'Phone Number',
                      context: context,
                      textController: phoneNumberTextController,
                      onPressed: () async {
                        try {
                          await userNotifier.updateUserPhoneNumber(
                            phoneNumberTextController.text,
                          );
                          Navigator.pop(context);
                          // ignore: avoid_catches_without_on_clauses
                        } catch (err) {
                          await GlobalMethods.errorDialog(
                            subtitle: err.toString(),
                            context: context,
                          );
                        }
                      },
                      textInputType: TextInputType.number,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _separateInfo({
    required Color color,
    required String title,
    required String userInformation,
    required Function onPressed,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: TextWidget(
          text: title,
          color: Colors.grey.shade500,
          textSize: 17,
        ),
      ),
      subtitle: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade500,
              width: 0.2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 5),
          child: TextWidget(
            text: userInformation,
            color: color,
            textSize: 20,
          ),
        ),
      ),
      onTap: () {
        // ignore: avoid_dynamic_calls
        onPressed();
      },
    );
  }

  Widget _textEditField({
    required String title,
    required BuildContext context,
    required TextEditingController textController,
    required Function onPressed,
    required TextInputType textInputType,
    double height = 500,
    int maxLines = 1,
  }) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Center(
                  child: Text(
                    'Edit $title',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: textController,
                      maxLines: maxLines,
                      keyboardType: textInputType,
                      validator: (value) {
                        if (title == 'Name' || title == 'Address') {
                          if (value!.isEmpty) {
                            return 'This Field is missing';
                          }
                        } else if (title == 'Email') {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                        } else if (title == 'Zip Code' ||
                            title == 'Phone Number') {
                          if (value!.isEmpty ||
                              !RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter the number';
                          }
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // ignore: avoid_dynamic_calls
                            onPressed();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectSex({
    required BuildContext context,
    required UserNotifier userNotifier,
  }) {
    return SizedBox(
      height: 200,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade500,
                          width: 0.3,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Center(
                        child: TextWidget(
                          text: 'Male',
                          color: Colors.blue.shade400,
                          textSize: 20,
                        ),
                      ),
                      onTap: () async {
                        await userNotifier.updateUserSex(0);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: TextWidget(
                        text: 'Female',
                        color: Colors.blue.shade400,
                        textSize: 20,
                      ),
                    ),
                    onTap: () async {
                      await userNotifier.updateUserSex(1);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                title: Center(
                  child: TextWidget(
                    text: 'Cancel',
                    color: Colors.blue.shade400,
                    textSize: 20,
                    isTitle: true,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectCountry({
    required BuildContext context,
    required UserNotifier userNotifier,
    required String userCountry,
    required Color color,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 15),
          child: Container(
            alignment: Alignment.topLeft,
            height: 54,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade500,
                  width: 0.2,
                ),
              ),
            ),
            child: TextWidget(
              text: 'Country',
              color: Colors.grey.shade500,
              textSize: 17,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CountryCodePicker(
              onChanged: (element) async {
                debugPrint(element.name);
                // ignore: inference_failure_on_function_invocation
                await showDialog(
                  context: context,
                  builder: (context) {
                    return Material(
                      color: Colors.transparent,
                      child: Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: Container(
                            height: 170,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      const Center(
                                        child: Text(
                                          'Edit Country',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Are you sure you want to change your country to ${element.name}?',
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                await userNotifier
                                                    .updateUserCountry(
                                                  element.code!,
                                                );
                                                Navigator.pop(context);
                                                // ignore: avoid_catches_without_on_clauses
                                              } catch (err) {
                                                await GlobalMethods.errorDialog(
                                                  subtitle: err.toString(),
                                                  context: context,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              textStyle: TextStyle(
                color: userCountry != '' ? color : Colors.transparent,
              ),
              showFlagMain: userCountry != '',
              initialSelection: userCountry,
              showCountryOnly: true,
              showOnlyCountryWhenClosed: true,
              alignLeft: true,
              countryFilter: const [
                'CN',
                'VN',
                'KR',
                'TW',
                'IN',
                'ID',
                'PH',
                'DE',
                'US',
                'CA',
                'GB',
                'FR',
                'AU'
              ],
            ),
          ),
        ),
      ],
    );
  }
}
