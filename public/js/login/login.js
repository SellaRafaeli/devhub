	var vm = new Vue({
		el: "#login",
		data: {
			email: "",
			submit_success: false,
			submit_failure: false,
			errMsg: "",
			kitten: false,
			error: getParameterByName('error')
		},

		methods: {
			loginRequest: function () {
				var login = this;
				$.post("/login", {email: this.email})
				.success(function(response){
					if (response.success) {
						login.submit_success = true;

						// window.location="http://localhost:9090/";
					} else if (response.error) {
						login.submit_failure = true;

						login.errMsg = response.error;
						// window.location="http://localhost:9090/contact";
					} else {
						login.submit_failure = true;
					}
					login.kitten = true;
					return
				})		
			}, //end loginRequest
		}, //end methods
		computed: {
			}
		});
