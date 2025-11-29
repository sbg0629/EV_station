package com.boot.fix.controller;

import com.boot.fix.dto.FixDTO;
import com.boot.fix.service.FixService;
import com.boot.common.dto.PageDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession; // HttpSession import 추가

import java.util.HashMap;
import java.util.List;

@Controller
public class FixController {

    private final FixService fixService;

    @Autowired
    public FixController(FixService fixService) {
        this.fixService = fixService;
    }

    // 고장 신고 폼 페이지
    @GetMapping("/report")
    public String showReportForm(Model model, HttpSession session, @RequestParam(value = "apiStatId", required = false) String apiStatId) {
        String memberId = (String) session.getAttribute("id"); // "memberId" -> "id"로 변경
        if (memberId == null) {
            return "redirect:/login";
        }
        FixDTO fixDTO = new FixDTO();
        fixDTO.setMemberId(memberId);
        if (apiStatId != null) {
            fixDTO.setApiStatId(apiStatId);
        }
        model.addAttribute("fixDTO", fixDTO);
        return "fix/reportForm";
    }

    // 고장 신고 제출
    @PostMapping("/report")
    public String submitReport(@ModelAttribute FixDTO fixDTO, Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("id"); // "memberId" -> "id"로 변경
        if (memberId == null) {
            // 로그인되어 있지 않으면 로그인 페이지로 리다이렉트
            return "redirect:/login"; // 로그인 페이지 URL로 변경 필요
        }
        fixDTO.setMemberId(memberId); // 세션에서 가져온 memberId를 DTO에 설정
        fixDTO.setStatus("접수"); // 고장 신고의 초기 상태를 '접수'로 설정
        fixService.registerReport(fixDTO);
        model.addAttribute("message", "고장 신고가 성공적으로 접수되었습니다.");
        return "fix/reportSuccess"; // fix/reportSuccess.jsp 뷰를 반환
    }

    // 모든 고장 신고 목록 조회 (관리자용) - 페이징 추가
    @GetMapping("/fixlist")
    public String listReports(
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model, HttpSession session) {
        Integer adminCk = (Integer) session.getAttribute("admin");
        if (adminCk == null || adminCk != 1) {
            return "redirect:/"; // 관리자가 아니면 메인 페이지로 리다이렉트
        }
        
        int pageSize = 10; // 한 페이지에 보여줄 개수
        
        // 전체 개수 조회
        int totalCount = fixService.getTotalCount();
        
        // 페이징 파라미터 설정
        HashMap<String, Object> param = new HashMap<>();
        param.put("startRow", (page - 1) * pageSize);
        param.put("pageSize", pageSize);
        
        // 페이징된 목록 조회
        List<FixDTO> reports = fixService.getAllReportsWithPaging(param);
        
        // PageDTO 생성
        PageDTO pageDTO = new PageDTO(page, totalCount, pageSize);
        
        model.addAttribute("reports", reports);
        model.addAttribute("pageDTO", pageDTO);
        
        return "fix/reportList";
    }

    // 특정 고장 신고 상세 조회 (관리자용)
    @GetMapping("/detail/{reportId}")
    public String getReportDetail(@PathVariable("reportId") Long reportId, Model model, HttpSession session) {
        Integer adminCk = (Integer) session.getAttribute("admin"); // "admin_ck" -> "admin"으로 변경
        if (adminCk == null || adminCk != 1) {
            return "redirect:/"; // 관리자가 아니면 메인 페이지로 리다이렉트
        }
        FixDTO report = fixService.getReportById(reportId);
        model.addAttribute("report", report);
        return "fix/reportDetail";
    }

    // 고장 신고 수정 폼 (관리자용)
    @GetMapping("/edit/{reportId}")
    public String showEditForm(@PathVariable("reportId") Long reportId, Model model, HttpSession session) {
        Integer adminCk = (Integer) session.getAttribute("admin"); // "admin_ck" -> "admin"으로 변경
        if (adminCk == null || adminCk != 1) {
            return "redirect:/"; // 관리자가 아니면 메인 페이지로 리다이렉트
        }
        FixDTO report = fixService.getReportById(reportId);
        model.addAttribute("fixDTO", report);
        return "fix/editReportForm";
    }

    // 고장 신고 수정 처리 (관리자용)
    @PostMapping("/edit")
    public String updateReport(@ModelAttribute FixDTO fixDTO, Model model, HttpSession session) {
        Integer adminCk = (Integer) session.getAttribute("admin"); // "admin_ck" -> "admin"으로 변경
        if (adminCk == null || adminCk != 1) {
            return "redirect:/"; // 관리자가 아니면 메인 페이지로 리다이렉트
        }

        fixService.updateReport(fixDTO);
        model.addAttribute("message", "고장 신고가 성공적으로 수정되었습니다.");
        return "fix/reportSuccess";
    }

    // 고장 신고 삭제 (관리자용)
    @PostMapping("/delete/{reportId}")
    public String deleteReport(@PathVariable("reportId") Long reportId, Model model, HttpSession session) {
        Integer adminCk = (Integer) session.getAttribute("admin"); // "admin_ck" -> "admin"으로 변경
        if (adminCk == null || adminCk != 1) {
            return "redirect:/"; // 관리자가 아니면 메인 페이지로 리다이렉트
        }
        fixService.deleteReport(reportId);
        model.addAttribute("message", "고장 신고가 성공적으로 삭제되었습니다.");
        return "redirect:/fixlist";
    }

    // 고장 신고를 바로 '처리 완료' 상태로 변경하는 엔드포인트 (관리자용)
    @PostMapping("/process/{reportId}")
    public String processReport(@PathVariable("reportId") Long reportId, HttpSession session) {
        Integer adminCk = (Integer) session.getAttribute("admin");
        if (adminCk == null || adminCk != 1) {
            return "redirect:/"; // 관리자가 아니면 메인 페이지로 리다이렉트
        }

        FixDTO fixDTO = fixService.getReportById(reportId);
        if (fixDTO != null) {
            fixDTO.setStatus("처리완료");
            // processedAt은 service.updateReport 내부에서 '처리완료' 상태일 때 자동으로 설정됨
            fixService.updateReport(fixDTO);
        }
        return "redirect:/fixlist"; // 처리 후 고장 신고 목록 페이지로 리다이렉트
    }

    // 회원 본인의 고장 신고 목록 조회
    @GetMapping("/myList")
    public String myReports(Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("id");
        if (memberId == null) {
            return "redirect:/login";
        }
        List<FixDTO> myReports = fixService.getReportsByMemberId(memberId);
        model.addAttribute("reports", myReports);
        return "fix/myReportList"; // 회원용 신고 목록 JSP
    }

    // 회원 본인의 고장 신고 상세 조회 (수정과 동일한 페이지 사용 가능)
    @GetMapping("/myDetail/{reportId}")
    public String myReportDetail(@PathVariable("reportId") Long reportId, Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("id");
        if (memberId == null) {
            return "redirect:/login";
        }
        FixDTO report = fixService.getReportById(reportId);
        // 본인 신고가 아니면 접근 제한
        if (report == null || !report.getMemberId().equals(memberId)) {
            return "redirect:/myList"; // 또는 오류 페이지
        }
        model.addAttribute("fixDTO", report);
        return "fix/myEditReportForm"; // 회원용 수정/상세 보기 JSP
    }

    // 회원 본인의 고장 신고 수정 처리
    @PostMapping("/myEdit")
    public String myUpdateReport(@ModelAttribute FixDTO fixDTO, Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("id");
        if (memberId == null) {
            return "redirect:/login";
        }

        FixDTO existingReport = fixService.getReportById(fixDTO.getReportId());
        // 본인 신고가 아니거나, 이미 처리된 신고는 수정 불가
        if (existingReport == null || !existingReport.getMemberId().equals(memberId) || !"접수".equals(existingReport.getStatus())) {
            model.addAttribute("message", "신고를 수정할 수 없습니다.");
            return "fix/reportSuccess"; // 오류 메시지 표시 후 리다이렉트
        }

        // 회원은 일부 필드만 수정 가능하도록 제한
        existingReport.setMalfunctionType(fixDTO.getMalfunctionType());
        existingReport.setDetailContent(fixDTO.getDetailContent());
        existingReport.setImageUrl(fixDTO.getImageUrl());

        fixService.updateReport(existingReport);
        model.addAttribute("message", "고장 신고가 성공적으로 수정되었습니다.");
        return "fix/reportSuccess";
    }

    // 회원 본인의 고장 신고 삭제
    @PostMapping("/myDelete/{reportId}")
    public String myDeleteReport(@PathVariable("reportId") Long reportId, Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("id");
        if (memberId == null) {
            return "redirect:/login";
        }

        FixDTO report = fixService.getReportById(reportId);
        // 본인 신고가 아니거나, 이미 처리된 신고는 삭제 불가
        if (report == null || !report.getMemberId().equals(memberId) || !"접수".equals(report.getStatus())) {
            model.addAttribute("message", "신고를 삭제할 수 없습니다.");
            return "fix/reportSuccess";
        }

        fixService.deleteReport(reportId);
        model.addAttribute("message", "고장 신고가 성공적으로 삭제되었습니다.");
        return "redirect:/myList";
    }
}
