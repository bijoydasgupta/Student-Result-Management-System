-- One-time compatibility migration for older installations.
-- It renames result_challenges (plural) to result_challenge (singular)
-- without deleting challenge rows. If the singular table already exists,
-- it leaves table data as-is and ensures notification linkage is present.
USE srms;

DROP PROCEDURE IF EXISTS migrate_result_challenge_table_name;
DELIMITER $$
CREATE PROCEDURE migrate_result_challenge_table_name()
BEGIN
  DECLARE plural_exists INT DEFAULT 0;
  DECLARE singular_exists INT DEFAULT 0;
  DECLARE related_column_exists INT DEFAULT 0;
  DECLARE plural_fk_name VARCHAR(64) DEFAULT NULL;
  DECLARE singular_fk_count INT DEFAULT 0;

  SELECT COUNT(*) INTO plural_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'result_challenges';
  SELECT COUNT(*) INTO singular_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'result_challenge';

  IF plural_exists > 0 AND singular_exists > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Both result_challenges and result_challenge exist. Compare/merge them manually before rerunning this migration.';
  ELSEIF plural_exists = 0 AND singular_exists = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Neither challenge table exists. Import migration_result_challenges.sql first.';
  END IF;

  SELECT COUNT(*) INTO related_column_exists
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'notifications'
      AND column_name = 'related_challenge_id';

  IF related_column_exists = 0 THEN
    ALTER TABLE notifications ADD COLUMN related_challenge_id INT UNSIGNED NULL AFTER related_request_id;
  END IF;

  IF plural_exists > 0 THEN
    SELECT constraint_name INTO plural_fk_name
      FROM information_schema.key_column_usage
      WHERE constraint_schema = DATABASE()
        AND table_name = 'notifications'
        AND column_name = 'related_challenge_id'
        AND referenced_table_name = 'result_challenges'
      LIMIT 1;

    IF plural_fk_name IS NOT NULL THEN
      SET @drop_fk_sql = CONCAT(
        'ALTER TABLE notifications DROP FOREIGN KEY `',
        REPLACE(plural_fk_name, '`', '``'),
        '`'
      );
      PREPARE drop_fk_stmt FROM @drop_fk_sql;
      EXECUTE drop_fk_stmt;
      DEALLOCATE PREPARE drop_fk_stmt;
    END IF;

    RENAME TABLE result_challenges TO result_challenge;
  END IF;

  SELECT COUNT(*) INTO singular_fk_count
    FROM information_schema.key_column_usage
    WHERE constraint_schema = DATABASE()
      AND table_name = 'notifications'
      AND column_name = 'related_challenge_id'
      AND referenced_table_name = 'result_challenge';

  IF singular_fk_count = 0 THEN
    ALTER TABLE notifications
      ADD CONSTRAINT fk_notifications_result_challenge
      FOREIGN KEY (related_challenge_id) REFERENCES result_challenge(id) ON DELETE CASCADE;
  END IF;
END$$
DELIMITER ;

CALL migrate_result_challenge_table_name();
DROP PROCEDURE migrate_result_challenge_table_name;
