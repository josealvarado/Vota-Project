
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.define("averageYears", function(request, response) {
  var query = new Parse.Query("TestObject");
  query.equalTo("foo", request.params.foo);
  query.find({
    success: function(results) {
      var sum = 0;
      for (var i = 0; i < results.length; ++i) {
        sum += results[i].get("Year");
      }
      response.success(sum / results.length);
    },
    error: function() {
      response.error("movie lookup failed");
    }
  });
});


Parse.Cloud.define("hasApp", function(request, response) {
	var dict = request.params.contacts;
	var num = 0;
	var found = 0;
  var error = 0;
  var phoneNumbers = "";
	for (var i = 0; i < dict.length; i++){
		var result = dict[i].phone_numbers;
		num += result.length;
		for (var j = 0; j < result.length; j++){
			phoneNumbers += result[j] + ", ";

			var query = new Parse.Query(Parse.User);
			query.equalTo("phone", result[j]);
			query.find({
        success: function(results) {
          found = 1;
  response.success("hasApp " + dict.length + " numbers " + num + " found " + found + " error " + error + " phoneNumbers " + phoneNumbers);
        },
        error: function() {
          error = 1;
        }
      });


			// query.each(function(user) {
   //      // Update to plan value passed in
   //      phoneNumbers += ":"+user.city;
   //      found = 1;
   //    }).then(function() {
   //      // Set the job's success status
   //      status.success("Migration completed successfully.");

   //    }, function(error) {
   //      // Set the job's error status
   //      status.error("Uh oh, something went wrong.");
   //      error = 1;
   //    });
		}
	}
  // response.success("hasApp " + dict.length + " numbers " + num + " found " + found + " error " + error + " phoneNumbers " + phoneNumbers);
});

Parse.Cloud.define("Comment", function(request) {
  // Our "Comment" class has a "text" key with the body of the comment itself
  var text = request.object.get('text');
  var from = request.object.get('from');
  var commentText = request.object.get('to');
  var to = request.object.get('phone');
  
  var query = new Parse.Query("QuestionTable");
  query.equalTo("phone", number);
  query.find({
    success: function(results) {

//       for (var i = 0; i < results.length; ++i) {
//         var user_id = results[i].get("objectId");
        
//         var pushQuery = new Parse.Query(Parse.Installation);
//   		pushQuery.equalTo('user', user_id);
//     
//   		Parse.Push.send({
//     		where: pushQuery, // Set our Installation query
//     		data: {
//       		alert: "New comment: " + commentText
//     		}
//   		}, {
//     		success: function() {
//       		// Push was successful
//     		},
//     		error: function(error) {
//       		throw "Got an error " + error.code + " : " + error.message;
//     		}
//   		});
        
        
//       }
      
      response.success("success");
    },
    error: function() {
      response.error("notification failed");
    }
  });
});

// Parse.Cloud.afterSave("Comment", function(request) {
//   // Our "Comment" class has a "text" key with the body of the comment itself
//   var commentText = request.object.get('text');
// 
//   var number = request.object.get('phone_number');
//   
//   var query = new Parse.Query("QuestionTable");
//   query.equalTo("phone", number);
//   query.find({
//     success: function(results) {
// 
//       for (var i = 0; i < results.length; ++i) {
//         var user_id = results[i].get("objectId");
//         
//         var pushQuery = new Parse.Query(Parse.Installation);
//   		pushQuery.equalTo('user', user_id);
//     
//   		Parse.Push.send({
//     		where: pushQuery, // Set our Installation query
//     		data: {
//       		alert: "New comment: " + commentText
//     		}
//   		}, {
//     		success: function() {
//       		// Push was successful
//     		},
//     		error: function(error) {
//       		throw "Got an error " + error.code + " : " + error.message;
//     		}
//   		});
//         
//         
//       }
//       
//       response.success("success");
//     },
//     error: function() {
//       response.error("notification failed");
//     }
//   });
//  
//   
// });