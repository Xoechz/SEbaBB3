-- test in different sessions
BEGIN
    top_salary_pkg.GetTopSalaries(0, 100000);
    top_salary_pkg.DoubleTopSalaries(0, 100000);
    top_salary_pkg.GetTopSalaries(0, 100000);

    -- only execute this in 1 session
    COMMIT;
END;