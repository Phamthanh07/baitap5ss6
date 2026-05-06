
/* 
   TẠI SAO LẠI CÓ THẢM HỌA 0 KẾT QUẢ?
   
   1. Bản chất của NULL: Trong SQL, NULL đại diện cho giá trị "không xác định" (unknown).
   
   2. Giải thích bằng toán học:
      Khi ta viết: room_id NOT IN (1, 2, NULL)
      Thực chất SQL sẽ phân tách thành: room_id <> 1 AND room_id <> 2 AND room_id <> NULL
      
   3. Logic ba giá trị (Three-valued Logic):
      Mọi phép so sánh trực tiếp với NULL (như room_id <> NULL) đều trả về UNKNOWN thay vì TRUE.
      Trong phép toán AND, nếu có bất kỳ thành phần nào là UNKNOWN, toàn bộ biểu thức sẽ 
      không bao giờ trả về TRUE.
      
      => Kết quả là mệnh đề WHERE không bao giờ khớp với bất kỳ dòng nào, dẫn đến 
         truy vấn trả về rỗng dù thực tế có rất nhiều "phòng chết".
*/

/* 
   CÁCH KHẮC PHỤC:
   
   - Cách 1 (Sửa Subquery): Thêm điều kiện lọc bỏ NULL trong tập con.
     WHERE room_id NOT IN (SELECT room_id FROM Bookings WHERE room_id IS NOT NULL)
     
   - Cách 2 (Sử dụng LEFT JOIN): Đây là cách tiếp cận trực quan và an toàn nhất.
     Ta thực hiện LEFT JOIN bảng Rooms với Bookings. Những phòng nào không có liên kết 
     (không được đặt) sẽ có giá trị tại các cột của bảng Bookings là NULL.
     
   - Cách 3 (NOT EXISTS): Thường được khuyến khích vì hiệu năng tốt và tránh được bẫy NULL.
*/

-- Giải pháp sử dụng LEFT JOIN + IS NULL (Được đánh giá là tối ưu và dễ hiểu nhất)

SELECT 
    r.room_id, 
    r.room_name
FROM 
    Rooms r
LEFT JOIN 
    Bookings b ON r.room_id = b.room_id
WHERE 
    -- Lọc ra những dòng không tìm thấy sự tương ứng trong bảng Bookings
    b.room_id IS NULL;

/* 
   GHI CHÚ: 
   Giải pháp này hoàn toàn miễn nhiễm với sự hiện diện của giá trị NULL 
   trong cột b.room_id và giúp Giám đốc sản phẩm tìm chính xác 100% 
   danh sách "Phòng chết" để đưa ra chính sách hạ giá.
*/
