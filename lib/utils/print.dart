import 'dart:convert';

mDebugPrint(msg) {

    print(msg);

}

mDebugPrintApi(msg) {

    mDebugPrint(
        "------------------------------------$msg----------------------------------------");

}

mDebugPrintApi2(msg) {

    mDebugPrint(
        "------------------------------------$msg----------------------------------------");

}

mDebugPrintRequest(data) {

    mDebugPrint("Request : ${jsonEncode(data)}");

}

mDebugPrintResponse(response) {

    mDebugPrint("Response : ${jsonEncode(response)}");

}

mDebugPrintError(msg) {

    mDebugPrint("Error : ${jsonEncode(msg)}");

}
