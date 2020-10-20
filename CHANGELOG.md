# Next Release

## 1.5.3 (10/20/2020)

* Fix zeitwerk autloading issue

## 1.5.2 (03/01/2019)

* Clearance has moved their controller methods to be private

## 1.5.1 (10/28/2018)

* Respect identifier when storing `original_user`
* Refactor code by awesomecode.io

## 1.5.0 (10/27/2017)

* Allow `SwitchUser.switch_back` to be considered even when not calling `#remember_user`.
* Use `redirect_back` for rails 5

## 1.4.0 (10/21/2016)

* Add ability to `store_sign_in` info with devise provider
* Respect `relative_url_root`
* Fix `selected_user_of_helper` bug

## 1.3.0 (07/23/2016)

* Add capybara support
* Add class and style options to `switch_user_select`
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
