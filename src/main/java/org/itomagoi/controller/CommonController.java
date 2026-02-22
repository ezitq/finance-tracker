package org.itomagoi.controller;

import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.itomagoi.service.FinanceRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class CommonController {

    private FinanceRecordService recordService;

    @Autowired
    public CommonController(FinanceRecordService recordService) {
        this.recordService = recordService;
    }

    @RequestMapping("/")
    public String showMainPage(Model model) {


        return "main-page";
    }
    @RequestMapping("/transaction-page")
    public String showTransactionPage(Model model) {

        FinanceRecordDto financeRecordDto = recordService.findAllRecords();

        model.addAttribute("financeRecords", financeRecordDto.getRecords());

        return "transactions";
    }

    @RequestMapping("/profile-page")
    public String shoProfilePage(Model model) {


        return "profile";
    }

//    @RequestMapping("/analytics-page")
//    public String showAnalyticsPage(Model model) {
//
//        FinanceRecordDto financeRecordDtoIncome = recordService.findFilteredRecords(FinanceRecordType.INCOME);
//        FinanceRecordDto financeRecordDtoExpense = recordService.findFilteredRecords(FinanceRecordType.EXPENSE);
//
//        recordService.
//
//
//        return "analytics";
//    }

    @RequestMapping("/analytics-page")
    public String showAnalyticsPage(Model model) {

        double incomeAmount = recordService.calculateIncome();
        double expenseAmount = recordService.calculateExpense();

// 1. Уявімо, що це ваші реальні витрати з бази даних
        Map<String, Double> expensesFromDb = new HashMap<>();
        expensesFromDb.put("Income", incomeAmount);
        expensesFromDb.put("Expense",expenseAmount);

        // 2. Перетворюємо це у формат, який любить CanvasJS (список мап з ключами "label" та "y")
        List<Map<String, Object>> dataPoints = new ArrayList<>();

        for (Map.Entry<String, Double> entry : expensesFromDb.entrySet()) {
            Map<String, Object> point = new HashMap<>();
            point.put("label", entry.getKey());
            point.put("y", entry.getValue());
            dataPoints.add(point);
        }

        // 3. Відправляємо на сторінку
        model.addAttribute("dataPointsList", dataPoints);
        return "analytics";
    }

    @RequestMapping("/goals-page")
    public String showGoalsPage(Model model) {


        return "goals";
    }


    @RequestMapping("/home-page")
    public String showHomePage(Model model) {

        FinanceRecordDto financeRecordDto = recordService.findAllRecords();

        double incomeAmount = recordService.calculateIncome();
        double expenseAmount = recordService.calculateExpense();
        double totalBalance = (expenseAmount * -1) + incomeAmount;

        model.addAttribute("financeRecords", financeRecordDto.getRecords());
        model.addAttribute("incomeAmount", incomeAmount);
        model.addAttribute("expenseAmount", expenseAmount);
        model.addAttribute("totalBalance", totalBalance);

        return "finance-tracker-page";
    }

    @RequestMapping(value = "/save-transaction", method = RequestMethod.POST)
    public String saveTransaction(
            @RequestHeader(value = "Referer", required = false) String referer,
            @RequestParam String category,
            @RequestParam double amount,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
            @RequestParam String type) {

        FinanceRecord financeRecord = new FinanceRecord(category, type, date, amount);
        // ... збереження в БД ...
        System.out.println("Збережено: " + financeRecord);
        recordService.saveRecord(financeRecord);

        System.out.println(referer);

        return "redirect:" + referer;
    }

    @RequestMapping(value = "/delete-transaction", method = RequestMethod.POST)
    public String deleteTransaction(@RequestParam int id) {

        recordService.deleteTransaction(id);

        return "redirect:/transaction-page";
    }

}
