@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: _onWillPop,
    child: Scaffold(
      appBar: AppBar(
        //... your existing app bar content
      ),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        //... your existing body content
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          onPressed: () {
            Get.to(AddNewPatients())?.then((value) {
              if (value != null && value) {
                Get.snackbar('Success', 'Patient data saved!');
              }
            });
          },
          child: Text(
            'Add New Patients',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    ),
  );
}
