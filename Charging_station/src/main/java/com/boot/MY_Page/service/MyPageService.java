package com.boot.MY_Page.service;

import java.util.HashMap;
import java.util.List;

import com.boot.MY_Page.dto.MyPageDTO;

public interface MyPageService {

	 List<MyPageDTO> list();
	 MyPageDTO getUserById(String memberId); 
	public void modify(HashMap<String, String> param);
	public void delete(HashMap<String, String> param);
}