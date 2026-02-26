package org.itomagoi.controller;

import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.dto.GoalRecordDto;
import org.itomagoi.entity.FinanceRecordType;
import org.itomagoi.entity.GoalRecord;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.service.FinanceRecordService;
import org.itomagoi.service.GoalRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.*;

@Controller
public class CommonController {

    private FinanceRecordService recordService;
    private GoalRecordService goalRecordService;

    @Autowired
    public CommonController(FinanceRecordService recordService, GoalRecordService goalRecordService) {
        this.goalRecordService = goalRecordService;
        this.recordService = recordService;
    }

    @RequestMapping("/")
    public String showMainPage(Model model) {

        return "main-page";
    }


    @RequestMapping("/transaction-page")
    public String showTransactionPage(Model model) {

        FinanceRecordDto financeRecordDto = recordService.findAllRecords();

        List<FinanceRecord> financeRecordList =  financeRecordDto.getRecords();

        model.addAttribute("financeRecords", financeRecordList);

        return "transactions";
    }

    @RequestMapping("/profile-page")
    public String shoProfilePage(Model model) {


        return "profile";
    }


    @RequestMapping("/analytics-page")
    public String showAnalyticsPage(Model model) {

       FinanceRecordDto recordsToAnalyze = recordService.findAllRecords();

        Map<String, Double> expensesFromDb = getStringDoubleMap(recordsToAnalyze);


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

    @NonNull
    private static Map<String, Double> getStringDoubleMap(FinanceRecordDto recordsToAnalyze) {
        List <FinanceRecord> financeRecordList = recordsToAnalyze.getRecords();

// 1. Уявімо, що це ваші реальні витрати з бази даних
        Map<String, Double> expensesFromDb = new HashMap<>();

        for(FinanceRecord record : financeRecordList){

            if(record.getType() == FinanceRecordType.GOAL
                    || record.getType() == FinanceRecordType.EXPENSE){
                expensesFromDb.put(record.getTitle(), record.getAmount() * - 1);

            }else {
                expensesFromDb.put(record.getTitle(), record.getAmount());

            }
        }
        return expensesFromDb;
    }

    @RequestMapping("/goals-page")
    public String showGoalsPage(Model model) {

        GoalRecordDto goalRecordDto = goalRecordService.findAllRecords();

        model.addAttribute("totalBalance", recordService.getTotalBalance());
        model.addAttribute( "goalRecords", goalRecordDto.getRecords());
        model.addAttribute("recordService", goalRecordService);

        return "goals";
    }

    @RequestMapping("/home-page")
    public String showHomePage(Model model) {

        FinanceRecordDto financeRecordDto = recordService.findAllRecords();

        GoalRecordDto goalRecordDto = goalRecordService.findAllRecords();

        double incomeAmount = recordService.getIncomeAmount();
        double expenseAmount = recordService.getExpenseAmount();
        double totalBalance = recordService.getTotalBalance();

        model.addAttribute("financeRecords", financeRecordDto.getRecords());
        model.addAttribute("incomeAmount", incomeAmount);
        model.addAttribute("expenseAmount", expenseAmount);
        model.addAttribute("totalBalance", totalBalance);
        model.addAttribute("goalRecord" , goalRecordDto.getRecords());

        return "finance-tracker-page";
    }

    @RequestMapping(value = "/save-transaction", method = RequestMethod.POST)
    public String saveTransaction(
            @RequestHeader(value = "Referer", required = false) String referer,
            @RequestParam String title,
            @RequestParam double amount,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
            @RequestParam String type) {

        FinanceRecord financeRecord = new FinanceRecord(title, type, date, amount);
        // ... збереження в БД ...
        System.out.println("Збережено: " + financeRecord);
        recordService.saveRecord(financeRecord);

        System.out.println(referer);

        return "redirect:" + referer;
    }

    @RequestMapping(value = "/save-goal", method = RequestMethod.POST)
    public String saveFinanceGoal(
            @RequestParam String category,
            @RequestParam double amount) {

        GoalRecord goalRecord = new GoalRecord(category,0.0 ,amount);

        goalRecordService.saveGoal(goalRecord);

        return "redirect:goals-page";
    }

    @RequestMapping(value = "/delete-goal", method = RequestMethod.POST)
    public String deleteGoalRecord(@RequestParam int id){

        goalRecordService.deleteGoal(id);

        return "redirect:/goals-page";

    }


    @RequestMapping(value = "/delete-transaction", method = RequestMethod.POST)
    public String deleteTransaction(@RequestParam int id) {

        FinanceRecord financeRecord = recordService.findRecordById(id);

            GoalRecord goalRecord = goalRecordService.findAllRecords()
                    .getRecords()
                    .stream()
                    .filter(gr -> gr.getTitle().equals(financeRecord.getTitle()))
                    .findFirst()
                    .get();

            goalRecord.setCurrentMoney(goalRecord.getCurrentMoney() - financeRecord.getAmount());


        recordService.deleteTransaction(id);

        return "redirect:/transaction-page";
    }


    @RequestMapping(value = "show-registration-page", method = RequestMethod.GET)
    public String showRegistrationPage(){


        return "registration-page";
    }

    @RequestMapping(value = "/update-transaction", method = RequestMethod.POST)
    public String updateTransaction(@RequestParam int id,
                                    @RequestParam int amount,
                                    @RequestParam String title,
                                    @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
                                    @RequestParam String type){

        FinanceRecord financeRecord = recordService.findRecordById(id);

        financeRecord.setAmount(amount);
        financeRecord.setDate(date);
        financeRecord.setTitle(title);
        financeRecord.setType(FinanceRecordType.valueOf(type));

        recordService.updateBalance();

        return "redirect:/transaction-page";
    }

    @RequestMapping(value = "/add-funds", method = RequestMethod.POST)
    public String addFunds(@RequestParam int id,
                           @RequestParam double amountToAdd) {

        goalRecordService.addFunds(id, amountToAdd);

        GoalRecord goalRecord = goalRecordService.findGoalRecordById(id);

        FinanceRecord financeRecord = new FinanceRecord(goalRecord.getTitle(), FinanceRecordType.GOAL,LocalDate.now(),amountToAdd);

        recordService.saveRecord(financeRecord);

        return "redirect:/goals-page";
    }

    @RequestMapping(value = "/force-add-funds", method = RequestMethod.POST)
    public String forceAddFunds(@RequestParam int id, @RequestParam double amount) {
        goalRecordService.addFunds(id, amount); // Додаємо без перевірок
        return "redirect:/goals-page";
    }

}
