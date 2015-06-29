# Next Release

## 1.0.2

* Don't attempt to query db if scope str isn't in scope_id str

## 1.0.1

* Fix typo in `GuestDataSource`
* Allow custom method as `available_users_names`

## 1.0.0 (06/22/2015)

* Performance improved, only load necessary data.
* Devise provider- don't store `sign_in` details
* Security :guardsman:, raise RoutingError in `developer_modes_only`
* Restore original user after sorcery logout
