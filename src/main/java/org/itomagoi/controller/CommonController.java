package org.itomagoi.controller;

import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.ConvertCurrency;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.GoalRecord;
import org.itomagoi.service.AuthorizationService;
import org.itomagoi.service.ChartService;
import org.itomagoi.service.FinanceRecordService;
import org.itomagoi.service.GoalRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;

@Controller
public class CommonController {

    private final FinanceRecordService recordService;
    private final GoalRecordService goalRecordService;
    private final AuthorizationService authorizationService;

    @Autowired
    public CommonController(FinanceRecordService recordService,
                            GoalRecordService goalRecordService,
                            AuthorizationService authorizationService) {
        this.recordService = recordService;
        this.goalRecordService = goalRecordService;
        this.authorizationService = authorizationService;
    }

    private AccountRecord getAuthUser(HttpSession session) {
        return (AccountRecord) session.getAttribute("currentUser");
    }

    private String redirectIfNotAuth(HttpSession session) {
        return getAuthUser(session) == null ? "redirect:/" : null;
    }

    @GetMapping("/")
    public String showMainPage(HttpSession session) {
        if (getAuthUser(session) != null) return "redirect:/home-page";
        return "main-page";
    }

    @GetMapping("/home-page")
    public String showHomePage(HttpSession session, Model model) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        model.addAttribute("financeRecords", recordService.findAllRecordsByUser(user).getRecords());
        model.addAttribute("incomeAmount", recordService.getIncomeAmountByUser(user));
        model.addAttribute("expenseAmount", recordService.getExpenseAmountByUser(user));
        model.addAttribute("totalBalance", recordService.getTotalBalanceByUser(user));
        model.addAttribute("goalRecords", goalRecordService.findAllRecordsByUser(user).getRecords());
        model.addAttribute("user", user);
        return "finance-tracker-page";
    }

    @GetMapping("/transaction-page")
    public String showTransactionPage(HttpSession session, Model model) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        model.addAttribute("financeRecords", recordService.findAllRecordsByUser(user).getRecords());
        model.addAttribute("user", user);
        return "transactions";
    }

    @GetMapping("/goals-page")
    public String showGoalsPage(HttpSession session, Model model) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        model.addAttribute("goalRecords", goalRecordService.findAllRecordsByUser(user).getRecords());
        model.addAttribute("totalBalance", recordService.getTotalBalanceByUser(user));
        model.addAttribute("user", user);
        return "goals";
    }

    @GetMapping("/show-registration-page")
    public String showRegistrationPage(HttpSession session) {
        if (getAuthUser(session) != null) return "redirect:/home-page";
        return "registration-page";
    }

    @GetMapping("/analytics-page")
    public String showAnalyticsPage(HttpSession session, Model model) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        FinanceRecordDto dto = recordService.findAllRecordsByUser(user);
        model.addAttribute("dataPointsList", ChartService.getStringDoubleMap(dto));
        model.addAttribute("user", user);
        return "analytics";
    }

    @GetMapping("/profile-page")
    public String showProfilePage(HttpSession session, Model model) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        model.addAttribute("user", user);
        model.addAttribute("currencies", ConvertCurrency.values());
        return "profile";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password,
                        HttpSession session, RedirectAttributes redirectAttributes) {
        AccountRecord user = authorizationService.validateUser(email, password);
        if (user != null) {
            session.setAttribute("currentUser", user);
            return "redirect:/home-page";
        }
        redirectAttributes.addFlashAttribute("loginError", "Невірний email або пароль");
        return "redirect:/";
    }

    @PostMapping("/register")
    public String register(@RequestParam String email, @RequestParam String password,
                           HttpSession session, RedirectAttributes redirectAttributes) {
        boolean success = authorizationService.registerAccount(email, password);
        if (!success) {
            redirectAttributes.addFlashAttribute("registerError", "Акаунт вже існує або дані некоректні");
            return "redirect:/";
        }
        AccountRecord user = authorizationService.validateUser(email, password);
        session.setAttribute("currentUser", user);
        return "redirect:/home-page";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @PostMapping("/save-transaction")
    public String saveTransaction(HttpSession session,
                                  @RequestParam String title,
                                  @RequestParam double amount,
                                  @RequestParam String type,
                                  @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
                                  @RequestHeader(value = "Referer", required = false) String referer) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        FinanceRecord record = new FinanceRecord(title, type, date, amount);
        record.setAccountRecord(user);
        recordService.saveRecord(record);

        return "redirect:" + (referer != null ? referer : "/home-page");
    }

    @PostMapping("/delete-transaction")
    public String deleteTransaction(HttpSession session, @RequestParam int id,
                                    @RequestHeader(value = "Referer", required = false) String referer) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        FinanceRecord record = recordService.findById(id);
        if (record != null && record.getAccountRecord().getEmail().equals(user.getEmail())) {
            recordService.deleteRecord(id);
        }

        return "redirect:" + (referer != null ? referer : "/home-page");
    }

    @PostMapping("/edit-transaction")
    public String editTransaction(HttpSession session,
                                  @RequestParam int id,
                                  @RequestParam String title,
                                  @RequestParam double amount,
                                  @RequestParam String type,
                                  @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
                                  @RequestHeader(value = "Referer", required = false) String referer) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        FinanceRecord record = recordService.findById(id);
        if (record != null && record.getAccountRecord().getEmail().equals(user.getEmail())) {
            record.setTitle(title);
            record.setAmount(amount);
            record.setType(org.itomagoi.entity.FinanceRecordType.valueOf(type));
            record.setDate(date);
        }

        return "redirect:" + (referer != null ? referer : "/home-page");
    }

    @PostMapping("/save-goal")
    public String saveGoal(HttpSession session,
                           @RequestParam String title,
                           @RequestParam double currentMoney,
                           @RequestParam double goalMoney,
                           @RequestHeader(value = "Referer", required = false) String referer) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        GoalRecord goal = new GoalRecord(title, currentMoney, goalMoney);
        goal.setAccountRecord(user);
        goalRecordService.saveGoal(goal);

        return "redirect:" + (referer != null ? referer : "/home-page");
    }

    @PostMapping("/delete-goal")
    public String deleteGoal(HttpSession session, @RequestParam int id,
                             @RequestHeader(value = "Referer", required = false) String referer) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        GoalRecord goal = goalRecordService.findById(id);
        if (goal != null && goal.getAccountRecord().getEmail().equals(user.getEmail())) {
            goalRecordService.deleteGoal(id);
        }

        return "redirect:" + (referer != null ? referer : "/home-page");
    }

    @PostMapping("/add-funds-to-goal")
    public String addFundsToGoal(HttpSession session, @RequestParam int id, @RequestParam double amount,
                                 @RequestHeader(value = "Referer", required = false) String referer) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        GoalRecord goal = goalRecordService.findById(id);
        if (goal != null && goal.getAccountRecord().getEmail().equals(user.getEmail())) {
            goalRecordService.addFunds(id, amount);
        }

        return "redirect:" + (referer != null ? referer : "/home-page");
    }

    @PostMapping("/update-profile")
    public String updateProfile(HttpSession session,
                                @RequestParam(required = false) String name,
                                @RequestParam(required = false) String secondName,
                                @RequestParam(required = false) String currency,
                                RedirectAttributes redirectAttributes) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        if (name != null && !name.isBlank()) authorizationService.updateName(user, name);
        if (secondName != null && !secondName.isBlank()) authorizationService.updateSecondName(user, secondName);
        if (currency != null && !currency.isBlank()) {
            try {
                authorizationService.updateCurrency(user, ConvertCurrency.valueOf(currency));
            } catch (IllegalArgumentException ignored) {}
        }

        redirectAttributes.addFlashAttribute("profileSuccess", "Профіль оновлено");
        return "redirect:/profile-page";
    }

    @PostMapping("/update-password")
    public String updatePassword(HttpSession session,
                                 @RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 RedirectAttributes redirectAttributes) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        boolean success = authorizationService.updatePassword(user, oldPassword, newPassword);
        if (!success) {
            redirectAttributes.addFlashAttribute("passwordError", "Невірний поточний пароль або новий пароль занадто короткий");
        } else {
            redirectAttributes.addFlashAttribute("passwordSuccess", "Пароль змінено");
        }

        return "redirect:/profile-page";
    }

    @PostMapping("/delete-account")
    public String deleteAccount(HttpSession session) {
        AccountRecord user = getAuthUser(session);
        if (user == null) return "redirect:/";

        authorizationService.deleteAccount(user);
        session.invalidate();
        return "redirect:/";
    }
}