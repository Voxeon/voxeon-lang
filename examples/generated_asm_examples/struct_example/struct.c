#include <stdlib.h>
#include <stdio.h>

struct BankAccount
{
	long balance;
	int id;
	short overdue;
};

struct BankAccount *new_bank_account(long balance, int id, short overdue)
{
	struct BankAccount *b = malloc(sizeof(struct BankAccount));
	b->balance = balance;
	b->id = id;
	b->overdue = overdue;

	return b;
}

int main()
{
	struct BankAccount *b = new_bank_account(1234, 5678, 91011);
	free(b);
	return 0;
}
