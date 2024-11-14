enum Status{
  LOADING, COMPLETED, ERROR
}


class LoadingModel {
  Status status;
  String message;

  LoadingModel({this.status = Status.LOADING, this.message = "Something went wrong"});

}
