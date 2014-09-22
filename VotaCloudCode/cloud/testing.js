// Parse.Cloud.define("averageYears", function(request, response) {
//   var query = new Parse.Query("TestObject");
//   query.equalTo("foo", request.params.foo);
//   query.find({
//     success: function(results) {
//       var sum = 0;
//       for (var i = 0; i < results.length; ++i) {
//         sum += results[i].get("Year");
//       }
//       response.success(sum / results.length);
//     },
//     error: function() {
//       response.error("movie lookup failed");
//     }
//   });
// });
