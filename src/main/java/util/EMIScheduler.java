package util;

import services.LoanService;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

@WebListener
public class EMIScheduler implements ServletContextListener {

    private Timer timer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        LoanService loanService = new LoanService();
        timer = new Timer("EMI-Scheduler", true);

        // ── Har mahine 1 tarikh ko run karo ──
        Calendar firstRun = Calendar.getInstance();
        firstRun.set(Calendar.DAY_OF_MONTH, 1);
        firstRun.set(Calendar.HOUR_OF_DAY, 0);
        firstRun.set(Calendar.MINUTE, 0);
        firstRun.set(Calendar.SECOND, 0);
        firstRun.set(Calendar.MILLISECOND, 0);

        // Agar is mahine ki 1 tarikh nikal gayi toh agle mahine ki 1 tarikh
        if (firstRun.getTime().before(new Date())) {
            firstRun.add(Calendar.MONTH, 1);
        }

        long monthlyInterval = 30L * 24 * 60 * 60 * 1000; // 30 days milliseconds

        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                System.out.println("[EMI Scheduler] Running monthly EMI deduction...");
                try {
                    loanService.processAutoEmi();
                    System.out.println("[EMI Scheduler] Done.");
                } catch (Exception e) {
                    System.out.println("[EMI Scheduler] Error: " + e.getMessage());
                }
            }
        }, firstRun.getTime(), monthlyInterval);

        System.out.println("[EMI Scheduler] Scheduled. Next run: " + firstRun.getTime());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel();
            System.out.println("[EMI Scheduler] Stopped.");
        }
    }
}