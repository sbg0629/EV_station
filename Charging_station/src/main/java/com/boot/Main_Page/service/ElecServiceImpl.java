package  com.boot.Main_Page.service;

import  java.util.ArrayList;
import  java.util.HashMap; 
import  java.util.List; 
import  java.util.Map; 

import  org.apache.ibatis.session.SqlSession;
import  org.springframework.beans.factory.annotation.Autowired;
import  org.springframework.stereotype.Service;

import  com.boot.Main_Page.dao.ElecDAO;
import  com.boot.Main_Page.dto.ElecDTO;

import  lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public  class  ElecServiceImpl  implements  ElecService  {

	@Autowired
	SqlSession  sqlSession;
	
	@Override
	public  ArrayList<ElecDTO>  list()  {
		ElecDAO  dao  =  sqlSession.getMapper(ElecDAO.class);
		ArrayList<ElecDTO>  list  =  dao.list();
		
		if  (list  !=  null  &&  !list.isEmpty())  { 
		      log.info("첫  번째  충전소  이름  (DB  조회  결과):  [{}]",  list.get(0).getStationName()); 
		} 
		
		return  list;
	}

      /**
        *  1.  반경  검색  구현
        */
      @Override
      public  List<ElecDTO>  findStationsByRadius(Map<String,  Object>  params)  {
            log.info("---  3.  Service  findStationsByRadius  진입  ---");
            ElecDAO  dao  =  sqlSession.getMapper(ElecDAO.class);
            List<ElecDTO>  list  =  dao.searchByRadius(params); 
            log.info("DAO  (Radius)  검색  결과  건수:  {}",  (list  !=  null)  ?  list.size()  :  0); 
            return  list;
      }

      /**
        *  2.  키워드  검색  구현
        */
      @Override
      public  List<ElecDTO>  findStationsByKeyword(Map<String,  Object>  params)  {
            log.info("---  3.  Service  findStationsByKeyword  진입  ---");
            ElecDAO  dao  =  sqlSession.getMapper(ElecDAO.class);
            List<ElecDTO>  list  =  dao.searchByKeyword(params); 
            log.info("DAO  (Keyword)  검색  결과  건수:  {}",  (list  !=  null)  ?  list.size()  :  0); 
            return  list;
      }
        
        /**
        *  3.  지도  영역  검색  구현
        */
      @Override
      public  List<ElecDTO>  findStationsByBounds(Map<String,  Object>  params)  {
            log.info("---  3.  Service  findStationsByBounds  진입  ---");
            ElecDAO  dao  =  sqlSession.getMapper(ElecDAO.class);
            List<ElecDTO>  list  =  dao.searchByBounds(params); 
            log.info("DAO  (Bounds)  검색  결과  건수:  {}",  (list  !=  null)  ?  list.size()  :  0); 
            return  list;
      }
}