--- QUESTION 1
SELECT COUNT(u_id)
FROM users;


--- QUESTION 2
SELECT COUNT(transfer_id)
FROM transfers
WHERE send_amount_currency = 'CFA' AND
	((kind = ‘transfer’) OR (kind = ‘payment’));


--- QUESTION 3
SELECT COUNT (DISTINCT (u_id))
FROM transfers
WHERE send_amount_currency = 'CFA' AND
	((kind = ‘transfer’) OR (kind = ‘payment’));


--- QUESTION 4
SELECT COUNT (atx_id)
FROM agent_transactions
WHERE EXTRACT (YEAR FROM when_created) = 2018
GROUP BY EXTRACT (MONTH FROM when_created);


--- QUESTION 5
SELECT COUNT (agent_id)
FROM agent_transactions
WHERE agent_transactions.when_created >= NOW()-interval '1 week' AND amount > 0 OR amount < 0
GROUP BY amount > 0;


--- QUESTION 6
SELECT COUNT (agent_transactions.atx_id)
AS atx_volume_city_summary, agents.city
FROM agent_transactions LEFT JOIN agents
ON agent_transactions.agent_id = agents.agent_id
WHERE agent_transactions.when_created > NOW()-interval '1 week'
GROUP BY agents.city;


--- QUESTION 7
SELECT City, Volume, Country INTO atx_volume_city_summary_with_Country 
FROM (Select agents.city AS City, agents.country AS Country, count(agent_transactions.atx_id) 
AS Volume FROM agents 
INNER JOIN agent_transactions ON agents.agent_id = agent_transactions.agent_id 
WHERE (agent_transactions.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY agents.country,agents.city) as atx_volume_summary_with_Country; 



--- QUESTION 8
SELECT SUM(transfers.send_amount_scalar)
AS send_volume_country, transfers.kind AS transfer_kind,
wallets.ledger_location AS country
FROM transfers
INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
WHERE transfers.when_created > NOW() -interval '1 week'
GROUP BY transfers.kind, wallets.ledger_location;



--- QUESTION 9
SELECT COUNT(transfers.source_wallet_id) 
AS Unique_Senders, 
COUNT (transfer_id) 
AS Transaction_Count, transfers.kind 
AS Transfer_Kind, wallets.ledger_location 
AS Country, 
SUM (transfers.send_amount_scalar) 
AS Volume 
FROM transfers 
INNER JOIN wallets 
ON transfers.source_wallet_id = wallets.wallet_id 
WHERE (transfers.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY wallets.ledger_location, transfers.kind; 
 



--- QUESTION 10
SELECT DISTINCT transfers.source_wallet_id
FROM transfers
WHERE send_amount_currency = 'CFA'
AND send_amount_scalar > 10000000
AND transfers.when_created BETWEEN > NOW() -interval '1 MONTH';