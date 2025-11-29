package com.boot.Notice.controller;


import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.Notice.dto.NoticeDTO;
import com.boot.Notice.service.NoticeService;
import com.boot.common.dto.PageDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NoticeController {
    
    @Autowired
    private NoticeService noticeService;

    // 🔧 공통적으로 admin 값을 안전하게 읽는 함수
    private Integer getAdminValue(HttpSession session) {
        if (session == null) return null;
        Object adminObj = session.getAttribute("admin");
        if (adminObj == null) return null;
        try {
            return Integer.parseInt(adminObj.toString());
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    // 공지사항 목록 페이지 - 페이징 추가
    @GetMapping("/notice")
    public String noticeList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "keyword", required = false) String keyword,
            HttpServletRequest request,
            Model model) {

        log.info("@# GET /notice page={}, category={}, keyword={}", page, category, keyword);
        
        HttpSession session = request.getSession(false);

        // 🔧 admin 값 안전 처리
        Integer admin = getAdminValue(session);
        model.addAttribute("adminCheck", admin);
        log.info("@# 공지사항 목록 - 세션 admin 값: {}", admin);

        // 고정 공지사항 조회
        List<NoticeDTO> fixedNotices = noticeService.getFixedNotices();
        model.addAttribute("fixedNotices", fixedNotices);
        
        int pageSize = 6;
        
        int totalCount = 0;
        List<NoticeDTO> notices;
        
        HashMap<String, Object> param = new HashMap<>();
        param.put("startRow", (page - 1) * pageSize);
        param.put("pageSize", pageSize);
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            param.put("keyword", keyword);
            totalCount = noticeService.getSearchCount(param);
            notices = noticeService.searchWithPaging(param);
            model.addAttribute("keyword", keyword);
        } else if (category != null && !category.isEmpty()) {
            param.put("category", category);
            totalCount = noticeService.getCategoryCount(category);
            notices = noticeService.listByCategoryWithPaging(param);
            model.addAttribute("category", category);
        } else {
            totalCount = noticeService.getTotalCount();
            notices = noticeService.listWithPaging(param);
        }
        
        PageDTO pageDTO = new PageDTO(page, totalCount, pageSize);
        model.addAttribute("notices", notices);
        model.addAttribute("pageDTO", pageDTO);
        
        return "notice/notice_list";
    }
    
    // 공지사항 상세 페이지
    @GetMapping("/notice/detail")
    public String noticeDetail(@RequestParam("noticeId") int noticeId, Model model) {
        log.info("@# GET /notice/detail noticeId={}", noticeId);
        
        NoticeDTO notice = noticeService.getNotice(noticeId);
        model.addAttribute("notice", notice);
        
        return "notice/notice_detail";
    }

    // 공지사항 작성 페이지
    @GetMapping("/notice/write")
    public String noticeWriteForm(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        Integer adminCk = getAdminValue(session);
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }
        
        return "notice/notice_write";
    }

    // 공지사항 작성 처리
    @PostMapping("/notice/write")
    public String noticeWrite(@RequestParam HashMap<String, String> param,
                              HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        Integer adminCk = getAdminValue(session);
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }

        param.put("member_id", (String) session.getAttribute("id"));
        noticeService.write(param);
        
        return "redirect:/notice";
    }

    // 공지사항 수정 페이지
    @GetMapping("/notice/modify")
    public String noticeModifyForm(@RequestParam("noticeId") int noticeId,
                                   HttpServletRequest request,
                                   Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        Integer adminCk = getAdminValue(session);
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }

        NoticeDTO notice = noticeService.notgetNotice(noticeId);
        model.addAttribute("notice", notice);
        
        return "notice/notice_modify";
    }

    // 공지사항 수정 처리
    @PostMapping("/notice/modify")
    public String noticeModify(@RequestParam HashMap<String, String> param,
                               HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        Integer adminCk = getAdminValue(session);
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }

        if (!param.containsKey("is_fixed") || param.get("is_fixed") == null || param.get("is_fixed").isEmpty()) {
            param.put("is_fixed", "0");
        }

        noticeService.modify(param);
        
        return "redirect:/notice/detail?noticeId=" + param.get("notice_id");
    }

    // 공지사항 삭제
    @PostMapping("/notice/delete")
    public String noticeDelete(@RequestParam("noticeId") int noticeId,
                               HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }

        Integer adminCk = getAdminValue(session);
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }

        noticeService.delete(noticeId);
        
        return "redirect:/notice";
    }
}
