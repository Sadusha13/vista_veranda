<?php
	$firstName = $_POST['firstName'];
	$lastName = $_POST['lastName'];
	$gender = $_POST['gender'];
	$email = $_POST['email'];
	$IDNumber = $_POST['id number'];
	$countrycode = $_POST['countrycode'];
	$number = $_POST['phonenumber'];

	// Database connection
	if (!empty($firstName) && !empty($lastName) && !empty($gender) && !empty($email) && !empty($IDNumber) && !empty($country) && !empty($number)) {
		$host="localhost";
		$dbfirstname="root";
		$dbidnumber= "";
		$dbname= "Book me";

		$conn = mysqli_connect($host, $dbusername, $dbpassword, $dbname);
		if (mysqli_connect_errno()) {
			die('Connect Error('. mysqli_connect_error().')'. mysqli_connect_error());
		}else{
			$SELECT = "SELECT email from register where email = ? Limit 1";
			$INSERT = "INTER into register (firstname,last name,idnumber,email,countrycode,phonenumber) values(?,?,?,?,?,?)"
			$stmt =$conn->prepare($SELECT);
			$stmt->bind_param("s", $email);
			$stmt->store_result();
			$rnum = $stmt->num_rows;
			$stmt = $conn->prepare($INSERT);
			$stmt->bind_param("ssssiii", $firstName, $lastName,$gender, $email, $IDNumber, $countrycode, $number);
			$stmt->execute();
			 echo "Your Booking successfully!";	
		}
		$stmt->close();
		$conn->close();
	 
	}	
?>
