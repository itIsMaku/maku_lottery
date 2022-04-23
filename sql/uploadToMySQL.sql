CREATE TABLE `lottery` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(40) DEFAULT NULL,
	`type` VARCHAR(20) NOT NULL,
	`run` INT NOT NULL,
	`win` INT NOT NULL,

	PRIMARY KEY (`id`)
);

CREATE TABLE `lottery_wins` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(40) DEFAULT NULL,
	`type` VARCHAR(20) NOT NULL,
	`price` INT NOT NULL,
	`claimed` INT NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `items` (name, label, weight) VALUES
	('ticket_Bronze', 'Lottery Ticket - Bronze', 1),
	('ticket_Silver', 'Lottery Ticket - Silver', 1),
	('ticket_Gold', 'Lottery Ticket - Gold', 1),
	('ticket_Diamond', 'Lottery Ticket - Diamond', 1)
;