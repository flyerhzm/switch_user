# Next Release

## 1.2.1 (12/22/2015)

* Fix `grouped_options_for_select` for rails 3.2

## 1.2.0 (12/01/2015)

* Replace select option to `group_option`

## 1.1.0 (07/01/2015)

* Rails 3.x compatibility
* Don't attempt to query db if scope str isn't in `scope_id` str
* Allow custom method as `available_users_names`

## 1.0.0 (06/22/2015)

* Performance improved, only load necessary data.
* Devise provider- don't store `sign_in` details
* Security :guardsman:, raise RoutingError in `developer_modes_only`
* Restore original user after sorcery logout
