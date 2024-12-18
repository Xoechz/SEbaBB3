-- COMPOUND TRIGGER
-- The compound trigger makes it easier to program an approach where you want the actions you 
-- implement for the various timing points to share common data.

CREATE OR REPLACE TRIGGER compound_trigger
    FOR UPDATE OF salary ON employees
    COMPOUND TRIGGER
    -- Declarative part (optional)
    threshold CONSTANT INTEGER := 200; -- common data/objects
    
    BEFORE STATEMENT IS
    BEGIN
       NULL;
    END BEFORE STATEMENT;
   
    BEFORE EACH ROW IS
    BEGIN
       NULL;
    END BEFORE EACH ROW;
   
    AFTER EACH ROW IS
    BEGIN
       NULL;
    END AFTER EACH ROW;
   
    AFTER STATEMENT IS
    BEGIN
       NULL;
    END AFTER STATEMENT;
   END compound_trigger;
/