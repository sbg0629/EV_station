package com.boot.MY_Page.service;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.MY_Page.dao.MyPageDAO;
import com.boot.MY_Page.dto.MyPageDTO;




@Service
public class MyPageServiceImpl implements MyPageService {
	@Autowired
	private SqlSession sqlSession;
	
	
	   @Override
	    public List<MyPageDTO> list() {
	        MyPageDAO dao = sqlSession.getMapper(MyPageDAO.class);
	        return dao.list();
	    }
	
	@Override
	public void modify(HashMap<String, String> param) {
		MyPageDAO dao = sqlSession.getMapper(MyPageDAO.class);
//		dao.modify(request.getParameter("boardNo")
//				 , request.getParameter("boardName")
//				 , request.getParameter("boardTitle")
//				 , request.getParameter("boardContent"));
	
		dao.modify(param);
	}

	@Override
	public void delete(HashMap<String, String> param) {
		MyPageDAO dao = sqlSession.getMapper(MyPageDAO.class);
//		dao.delete(request.getParameter("boardNo"));
		dao.delete(param);
	}

	@Override
	public MyPageDTO getUserById(String memberId) {
	    MyPageDAO dao = sqlSession.getMapper(MyPageDAO.class);
	    return dao.getUserById(memberId);
	}


}