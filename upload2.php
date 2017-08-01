<?php
    //取得客戶端送來資料

	$image = file_get_contents("php://input");
    $account        = $_REQUEST['account'];
    $password       = $_REQUEST['password'];
	if (!$image) {
	    echo '画像取得に失敗しました。<br>';
	}
    echo "arrived";
    //ファイル名を作成
	$filename = 'upload/'.date('YmdHis').'.jpg';

	// 取得したバイナリデータを画像(png)として保存.
	file_put_contents($filename,$image);

    $link = mysqli_connect("127.0.0.1","root","qwer9999");
    if($link){
            //echo '連線成功<br>';
            ///切換資料庫
            mysqli_query($link,"use election");
            ///確認使用者帳號密碼是否存在
            $sql = "select sn_id from election.member where account='$account' and password='$password';";

            $num_result = mysqli_query($link,$sql);
            $num = mysqli_num_rows($num_result);

            //確認有這個使用者，取得使用者的sn_id
            if ($num == 1){
                $result_sn_id_row = mysqli_fetch_row($num_result);
                $sn_id = $result_sn_id_row[0];
                echo 'YES'."::".$sn_id;
           
                $fp      = fopen($filename, 'r');
                $content = fread($fp, filesize($filename));
                $content = addslashes($content);
                fclose($fp);
            
                //$file =  read_file();
                //將圖片寫進資料庫
                $sql_update_photo = "update election.self_data set self_photo = '$content' where sn_id='$sn_id';";
                $update_photo_result = mysqli_query($link,$sql_update_photo);
                if (mysqli_query($link,$sql_update_photo)) {
                    echo "Record updated successfully";
                } else {
                    echo "Error updating record: " . mysqli_error($link);
                }
                
             } else {
                echo $num;
            }

        } else {
            echo 'CONNECT_PROBLEM';
        }


/*
	//ファイル名を作成
	$filename = date('YmdHis').'.jpg';

	// 取得したバイナリデータを画像(png)として保存.
	file_put_contents('upload/'.$filename,$image);
*/

?>