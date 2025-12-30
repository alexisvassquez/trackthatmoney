import '../../models/model_mapping.dart';

/// Track That Money
/// lib/ui/dashboard/data/mock_data_expenses.dart

const String kDemoUserUuid = '11111111-2222-3333-4444-555555555555';

final List<DomainExpense> top5DomainExpenses = [
  DomainExpense.create(
    userUuid: kDemoUserUuid, 
    merchant: 'Publix', 
    category: 'Groceries', 
    amountCents: 4267, 
    date: DateTime(2025, 9, 4), 
    isSubscription: false,
  ),
  DomainExpense.create(
    userUuid: kDemoUserUuid, 
    merchant: 'BCT', 
    category: 'Transportation', 
    amountCents: 500, 
    date: DateTime(2025, 9, 3), 
    isSubscription: false,
  ),
  DomainExpense.create(
    userUuid: kDemoUserUuid, 
    merchant: 'Spotify', 
    category: 'Subscription', 
    amountCents: 1199, 
    date: DateTime(2025, 9, 4), 
    isSubscription: true,
  ),
  DomainExpense.create(
    userUuid: kDemoUserUuid, 
    merchant: 'Google Fi', 
    category: 'Phone', 
    amountCents: 5536, 
    date: DateTime(2025, 9, 3), 
    isSubscription: true,
  ),
  DomainExpense.create(
    userUuid: kDemoUserUuid, 
    merchant: 'Bandcamp', 
    category: 'Merch', 
    amountCents: 1084, 
    date: DateTime(2025, 9, 2), 
    isSubscription: false,
  ),
];
