module.exports = function(grunt) {
    var css_files = new Array('client/css/fullcalendar.css', 'client/css/bootstrap-datetimepicker.min.css', 'client/css/bootstrap.css', 'client/css/jquery.dockmodal.css', 'client/css/select2-bootstrap.css', 'client/css/flag.css', 'client/css/highlight-github.css', 'client/css/jquery-ui.css');
    var js_files = new Array('client/js/libs/jquery-1.8.3.js', 'client/js/libs/jquery.placeholder.js', 'client/js/libs/emojify.min.js', 'client/js/libs/jquery-ui-1.8.23.js', 'client/js/libs/jquery.drawDoughnutChart.js', 'client/js/libs/underscore.js', 'client/js/libs/backbone.js', 'client/js/libs/backbone.stickit.js', 'client/js/libs/backbone.dualstorage.js', 'client/js/libs/affix.js', 'client/js/libs/bootstrap-twipsy.js', 'client/js/libs/bootstrap-tooltip.js', 'client/js/libs/bootstrap-popover.js', 'client/js/libs/bootstrap-dropdown.js', 'client/js/libs/bootstrap-datetimepicker.min.js', 'client/js/libs/bootstrap-collapse.js', 'client/js/libs/bootstrap-alert.js', 'client/js/libs/bootstrap-transition.js', 'client/js/libs/bootstrap-tab.js', 'client/js/libs/bootstrap-modal.js', 'client/js/libs/md5.js', 'client/js/libs/select2.js', 'client/js/libs/ImageSelect.jquery.js', 'client/js/libs/date.format.js', 'client/js/libs/jquery.gritter.min.js', 'client/js/libs/jquery.scrollTo-min.js', 'client/js/libs/jquery.dockmodal.js', 'client/js/libs/Markdown.Converter.js', 'client/js/libs/tag-it.js', 'client/js/libs/jquery.iframe-transport.js', 'client/js/libs/highlight.js', 'client/js/libs/showdown.js', 'client/js/libs/xss.min.js', 'client/js/libs/showdown-target-blank.min.js', 'client/js/libs/showdown-xss-filter.js', 'client/js/libs/fullcalendar.min.js', 'client/js/libs/load-image.min.js', 'client/js/libs/tmpl.min.js', 'client/js/libs/jquery.ui.widget.js', 'client/js/libs/jquery.cookie.js', 'client/js/libs/jquery.fileupload.js', 'client/js/libs/jquery.fileupload-process.js', 'client/js/libs/jquery.fileupload-image.js', 'client/js/libs/jquery.fileupload-validate.js', 'client/js/libs/jquery.bootstrap-growl.js', 'client/js/libs/backbone.defered-view-loader.js', 'client/js/libs/backbone.upload-manager.js', 'client/js/libs/backbone-batch-operations.js', 'client/js/libs/jquery-bootstrap-pagination.js', 'client/js/libs/jquery.fn.gantt.js', 'client/js/libs/jquery.sparkline.js', 'client/js/libs/localforage.js', 'client/js/libs/locale.js', 'client/js/libs/splitter.js', 'client/js/libs/musical.js', 'client/js/libs/favico-0.3.8.min.js', 'client/js/libs/i18next.min.js', 'client/js/libs/i18nextXHRBackend.min.js', 'client/js/libs/i18nextSprintfPostProcessor.min.js', 'client/js/libs/jquery.hotkeys.js', 'client/js/libs/backbone-hotkeys.js', 'client/js/libs/backbone-forms.js', 'client/js/libs/jquery.printPage.js', 'client/js/libs/jquery.ui.touch-punch.js', 'client/js/libs/moment.js', 'client/js/libs/moment-timezone.js', 'client/js/libs/moment-timezone-with-data.js', 'client/js/models/oauth.js', 'client/js/models/user.js', 'client/js/models/board.js', 'client/js/models/boards_subscriber.js', 'client/js/models/list.js', 'client/js/models/flickr.js', 'client/js/models/organization.js', 'client/js/models/list_subscriber.js', 'client/js/models/card.js', 'client/js/models/organizations_user.js', 'client/js/models/boards_user.js', 'client/js/models/activity.js', 'client/js/models/card_voter.js', 'client/js/models/card_label.js', 'client/js/models/card_subscriber.js', 'client/js/models/card_attachment.js', 'client/js/models/label.js', 'client/js/models/checklist.js', 'client/js/models/checklist_item.js', 'client/js/models/card_user.js', 'client/js/models/elasticsearch.js', 'client/js/models/workflow_template.js', 'client/js/models/acl.js', 'client/js/models/role.js', 'client/js/models/role_setting.js', 'client/js/models/setting_category.js', 'client/js/models/boards_star.js', 'client/js/models/instant_card_add.js', 'client/js/models/email_template.js', 'client/js/models/app.js', 'client/js/models/oauth_client.js', 'client/js/models/oauth_application.js', 'client/js/models/acl_board_links.js', 'client/js/models/board_user_roles.js', 'client/js/models/acl_organization_links.js', 'client/js/models/organization_user_roles.js', 'client/js/models/chat_history.js', 'client/js/collections/user_collection.js', 'client/js/collections/attachment_collection.js', 'client/js/collections/list_collection.js', 'client/js/collections/flickr_collection.js', 'client/js/collections/organization_collection.js', 'client/js/collections/organizations_user_collection.js', 'client/js/collections/boards_user_collection.js', 'client/js/collections/activity_collection.js', 'client/js/collections/board_subscriber_collection.js', 'client/js/collections/card_collection.js', 'client/js/collections/board_collection.js', 'client/js/collections/card_attachment_collection.js', 'client/js/collections/card_label_collection.js', 'client/js/collections/card_position_collection.js', 'client/js/collections/card_checklist_collection.js', 'client/js/collections/checklist_item_collection.js', 'client/js/collections/card_voter_collection.js', 'client/js/collections/elasticsearch_collection.js', 'client/js/collections/workflow_template_collection.js', 'client/js/collections/list_subscriber_collection.js', 'client/js/collections/card_subscriber_collection.js', 'client/js/collections/card_user_collection.js', 'client/js/collections/acl_collection.js', 'client/js/collections/role_collection.js', 'client/js/collections/setting_category_collection.js', 'client/js/collections/board_star_collection.js', 'client/js/collections/email_template_collection.js', 'client/js/collections/role_settings_collection.js', 'client/js/collections/app_collection.js', 'client/js/collections/oauth_client_collection.js', 'client/js/collections/oauth_application_collection.js', 'client/js/collections/acl_board_links_collection.js', 'client/js/collections/organization_user_roles_collection.js', 'client/js/collections/acl_organization_links_collection.js', 'client/js/collections/board_user_roles_collection.js', 'client/js/collections/chat_history_collection.js', 'client/js/templates/templates.js', 'client/js/views/application_view.js', 'client/js/views/admin_user_add_view.js', 'client/js/views/register_view.js', 'client/js/views/login_view.js', 'client/js/views/list_view.js', 'client/js/views/activity_view.js', 'client/js/views/board_view.js', 'client/js/views/header_view.js', 'client/js/views/footer_view.js', 'client/js/views/boards_index_view.js', 'client/js/views/users_forgot_password_view.js', 'client/js/views/users_activation_view.js', 'client/js/views/users_change_password_view.js', 'client/js/views/organization_view.js', 'client/js/views/organizations_user_view.js', 'client/js/views/boards_user_view.js', 'client/js/views/chat_view.js', 'client/js/views/card_view.js', 'client/js/views/modal_card_view.js', 'client/js/views/modal_list_view.js', 'client/js/views/modal_board_view.js', 'client/js/views/attachment_view.js', 'client/js/views/card_attachment_view.js', 'client/js/views/card_label_view.js', 'client/js/views/card_checklist_view.js', 'client/js/views/card_checklist_item_view.js', 'client/js/views/user_view.js', 'client/js/views/user_index_view.js', 'client/js/views/board_simple_view.js', 'client/js/views/instant_card_add_view.js', 'client/js/views/role_index_view.js', 'client/js/views/role_settings_view.js', 'client/js/views/user_cards_view.js', 'client/js/views/user_activity_menu_view.js', 'client/js/views/user_boards_listing_menu_view.js', 'client/js/views/user_search_result_view.js', 'client/js/views/organization_visibility_form_view.js', 'client/js/views/organization_member_permission_form_view.js', 'client/js/views/organization_member_remove_form_view.js', 'client/js/views/organization_member_confirm_remove_form_view.js', 'client/js/views/attachment_delete_confirm_form_view.js', 'client/js/views/attachment_delete_confirm_form_view.js', 'client/js/views/board_organization_form_view.js', 'client/js/views/board_custom_background_view.js', 'client/js/views/board_sidebar_view.js', 'client/js/views/archived_items_view.js', 'client/js/views/board_background_view.js', 'client/js/views/board_filter_view.js', 'client/js/views/board_user_activity_view.js', 'client/js/views/board_user_remove_confirm_view.js', 'client/js/views/card_copy_view.js', 'client/js/views/list_archive_confirm_view.js', 'client/js/views/list_cards_archive_confirm_view.js', 'client/js/views/move_cards_from_list_view.js', 'client/js/views/move_list_view.js', 'client/js/views/copy_list_view.js', 'client/js/views/list_delete_confirm_view.js', 'client/js/views/list_actions_view.js', 'client/js/views/card_labels_form_view.js', 'client/js/views/card_positions_form_view.js', 'client/js/views/card_member_form_view.js', 'client/js/views/card_actions_view.js', 'client/js/views/activity_user_add_search_result_view.js', 'client/js/views/card_voters_list_view.js', 'client/js/views/activity_delete_confirm_view.js', 'client/js/views/edit_activity_form_view.js', 'client/js/views/activity_reply_form_view.js', 'client/js/views/activity_add_form_view.js', 'client/js/views/card_duedate_from_view.js', 'client/js/views/card_label_form_view.js', 'client/js/views/emoji_list_view.js', 'client/js/views/checklist_item_emoji_list_view.js', 'client/js/views/admin_user_index_view.js', 'client/js/views/admin_boards_list_view.js', 'client/js/views/oauth_applications_view.js', 'client/js/views/oauth_client_view.js', 'client/js/views/oauth_client_add_view.js', 'client/js/views/oauth_client_edit_view.js', 'client/js/views/oauth_applications_view.js', 'client/js/views/app_view.js', 'client/js/views/app_setting_view.js', 'client/js/views/card_search_result_view.js', 'client/js/views/copy_from_existing_card_view.js', 'client/js/views/move_card_view.js', 'client/js/views/copy_card_view.js', 'client/js/views/activity_card_search_view.js', 'client/js/views/checklist_add_form_view.js', 'client/js/views/modal_card_member_form_view.js', 'client/js/views/card_search_users_result_view.js', 'client/js/views/notification_menu_view.js', 'client/js/views/organization_add_view.js', 'client/js/views/board_add_view.js', 'client/js/views/organizations_board_form_view.js', 'client/js/views/user_cards_view.js', 'client/js/views/checklist_item_add_form_view.js', 'client/js/views/checklist_delete_confirm_form_view.js', 'client/js/views/checklist_actions_view.js', 'client/js/views/checklist_item_actions_view.js', 'client/js/views/checklist_item_delete_confirm_form_view.js', 'client/js/views/checklist_item_edit_form_view.js', 'client/js/views/checklist_item_add_link_view.js', 'client/js/views/checklist_edit_form_view.js', 'client/js/views/attachment_delete_confirm_view.js', 'client/js/views/setting_view.js', 'client/js/views/instant_card_add_labels_form_view.js', 'client/js/views/instant_card_add_members_form_view.js', 'client/js/views/switch_to_list_form_view.js', 'client/js/views/user_activity_menu_view.js', 'client/js/views/user_board_list_view.js', 'client/js/views/archived_lists_view.js', 'client/js/views/archived_list_view.js', 'client/js/views/archived_cards_view.js', 'client/js/views/archived_card_view.js', 'client/js/views/edit_board_member_permission_to_normal_view.js', 'client/js/views/copy_board_visibility_view.js', 'client/js/views/show_all_visibility_view.js', 'client/js/views/show_board_member_permission_form_view.js', 'client/js/views/show_board_visibility_view.js', 'client/js/views/show_search_message_view.js', 'client/js/views/search_result_view.js', 'client/js/views/show_search_boards_view.js', 'client/js/views/search_board_subscribe_view.js', 'client/js/views/show_boards_list_view.js', 'client/js/views/my_boards_listing_view.js', 'client/js/views/started_boards_listing_view.js', 'client/js/views/closed_boards_listing_view.js', 'client/js/views/board_additional_setting_view.js', 'client/js/views/select_board_visibility_view.js', 'client/js/views/board_visibility_view.js', 'client/js/views/board_add_organization_form_view.js', 'client/js/views/board_member_add_search_result_view.js', 'client/js/views/checklist_item_mention_member_view.js', 'client/js/views/checklist_item_mention_member_search_form_view.js', 'client/js/views/organization_board_view.js', 'client/js/views/user_boards_listing_menu_view.js', 'client/js/views/board_user_actions_view.js', 'client/js/views/modal_user_activities_list_view.js', 'client/js/views/organizations_lists_view.js', 'client/js/views/organizations_list_view.js', 'client/js/views/email_template_view.js', 'client/js/views/user_activity_view.js', 'client/js/views/user_index_container_view.js', 'client/js/views/selected_board_visibility_view.js', 'client/js/views/modal_activity_view.js', 'client/js/views/modal_flickr_photo_view.js', 'client/js/views/modal_music_view.js', 'client/js/views/flickr_view.js', 'client/js/views/board_404_view.js', 'client/js/views/organization_header_view.js', 'client/js/views/user_view_header_view.js', 'client/js/views/organizations_lists_header_view.js', 'client/js/views/board_header_view.js', 'client/js/views/starred_boards_index_view.js', 'client/js/views/organization_delete_form_view.js', 'client/js/views/error_404_view.js', 'client/js/views/board_index_header_view.js', 'client/js/views/about_us_view.js', 'client/js/views/closed_boards_index_view.js', 'client/js/views/activity_index_view.js', 'client/js/views/admin_activity_index_view.js', 'client/js/views/show_sync_google_calendar_view.js', 'client/js/views/show_copy_board_view.js', 'client/js/views/music_repeat_view.js', 'client/js/views/admin_board_view.js', 'client/js/views/admin_boards_index_view.js', 'client/js/views/email_to_board_setting_view.js', 'client/js/views/qr_code_view.js', 'client/js/views/user_dashboard_view.js', 'client/js/views/search_page_result_view.js', 'client/js/views/board_labels_view.js', 'client/js/views/board_labels_edit_view.js', 'client/js/views/label_delete_confirm_view.js', 'client/js/views/subscribe_board_confirm_view.js', 'client/js/views/unsubscribe_board_confirm_view.js', 'client/js/views/archive_card_delete_confirm_view.js', 'client/js/views/archive_list_delete_confirm_view.js', 'client/js/views/modal_shortcut_view.js', 'client/js/views/modal_chat_history_view.js', 'client/js/views/chat_history_view.js', 'client/js/common.js', 'client/js/application.js');
    var source_js_files = new Array('Gruntfile.js', 'client/js/collections/**/*.js', 'client/js/models/**/*.js', 'client/js/views/**/*.js', 'client/js/application.js', 'client/js/common.js', 'client/apps/**/js/*.js');
    var backbone_source_js_files = new Array('client/js/collections/**/*.js', 'client/js/models/**/*.js', 'client/js/views/**/*.js');
    var authorize_js_files = new Array('client/js/libs/jquery-1.8.3.js', 'client/js/libs/bootstrap-alert.js', 'client/js/libs/jquery.bootstrap-growl.js');
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        jshint: {
            all: source_js_files
        },
        eslint: {
            src: source_js_files
        },
        closureCompiler: {
            options: {
                compilerFile: 'compiler/compiler.jar',
                checkModified: true,
                compilerOpts: {
                    compilation_level: 'ADVANCED_OPTIMIZATIONS',
                    define: ["'goog.DEBUG=false'"],
                    warning_level: 'verbose',
                    jscomp_off: ['checkTypes', 'fileoverviewTags'],
                    summary_detail_level: 3,
                    output_wrapper: '"(function(){%output%}).call(this);"'
                },
                execOpts: {
                    maxBuffer: 999999 * 1024
                },
                d32: true,
                TieredCompilation: true
            },
            targetName: {
                src: 'client/js/default.cache.js',
                dest: 'client/js/default.cache.compiled.js'
            }
        },
        phplint: {
            all: ['server/php/R/*.php', 'server/php/shell/*.php', 'server/php/libs/*.php']
        },
        phpcs: {
            application: {
                dir: ['server/php/R/*.php', 'server/php/shell/*.php', 'server/php/libs/*.php']
            },
            options: {
                standard: 'PEAR'
            }
        },
        less: {
            development: {
                files: {
                    'client/css/bootstrap.css': 'client/css/bootstrap.less',
                    'client/css/authorize.css': 'client/css/authorize.less'
                }
            }
        },
        jst: {
            compile: {
                options: {
                    processName: function(filepath) {
                        return filepath.replace('client/js/', '').replace('.jst.ejs', '');
                    }
                },
                files: {
                    'client/js/templates/templates.js': 'client/js/templates/**/*.ejs',
                }
            }
        },
        concat: {
            css: {
                src: css_files,
                dest: 'client/css/default.cache.css'
            },
            js: {
                src: js_files,
                dest: 'client/js/default.cache.js'
            },
            authorize_js: {
                src: authorize_js_files,
                dest: 'client/js/authorize.cache.js'
            }
        },
        jsbeautifier: {
            'pre-merge': {
                src: source_js_files,
                options: {
                    mode: 'VERIFY_ONLY'
                }
            },
            default: {
                src: source_js_files
            }
        },
        prettify: {
            options: {
                indent: 1,
                'unformatted': [
                    'a',
                    'script'
                ]
            },
            index: {
                src: 'client/index.html',
                dest: 'client/index.html'
            },
            api_explorer: {
                src: 'api_explorer/index.html',
                dest: 'api_explorer/index.html'
            }
        },
        cssmin: {
            options: {
                keepSpecialComments: 0
            },
            css: {
                src: 'client/css/default.cache.css',
                dest: 'client/css/default.cache.css'
            }
        },
        uglify: {
            main: {
                files: {
                    'client/js/default.cache.js': ['client/js/default.cache.js']
                }
            },
            authorize: {
                files: {
                    'client/js/authorize.cache.js': ['client/js/authorize.cache.js']
                }
            },
            apps: {
                files: [{
                    expand: true,
                    cwd: 'client/apps',
                    src: '**/js/*.js',
                    dest: 'client/apps'
                }]
            }
        },
        filerev: {
            live: {
                src: ['client/js/default.cache.js', 'client/css/default.cache.css']
            }
        },
        usemin: {
            html: ['client/index.html', 'server/php/authorize.php']
        },
        htmlmin: {
            main: {
                options: {
                    removeComments: true,
                    collapseWhitespace: true
                },
                files: {
                    'client/index.html': 'client/index.html'
                }
            }
        },
        'regex-replace': {
            deploy: {
                src: ['client/index.html'],
                actions: [{
                    name: '',
                    search: '/restyaboard/',
                    replace: '/',
                    flags: 'g'
                }]
            },
            replace: {
                src: ['client/index.html', 'server/php/config.inc.php'],
                actions: [{
                    name: 'Debug mode Replace',
                    search: '\'R_DEBUG\', true',
                    replace: '\'R_DEBUG\', false',
                    flags: 'g'
                }, {
                    name: 'DB User',
                    search: '\'restya\'',
                    replace: '\'<%= config.db_user %>\'',
                    flags: 'g'
                }, {
                    name: 'DB Password',
                    search: 'hjVl2!rGd',
                    replace: '<%= config.db_password %>',
                    flags: 'g'
                }, {
                    name: 'DB Name',
                    search: '\'restyaboard\'',
                    replace: '\'<%= config.db_name %>\'',
                    flags: 'g'
                }, {
                    name: 'Manifest Replace',
                    search: '<html class="no-js" lang="en">',
                    replace: '<html class="no-js" lang="en" manifest="default.appcache">',
                    flags: 'g'
                }, {
                    name: 'DB Host',
                    search: '\'CHAT_DB_HOST\', \'localhost\'',
                    replace: '\'CHAT_DB_HOST\', \'<%= config.chat_db_host %>\'',
                    flags: 'g'
                }, {
                    name: 'DB User',
                    search: '\'ejabb\'',
                    replace: '\'<%= config.chat_db_user %>\'',
                    flags: 'g'
                }, {
                    name: 'DB Password',
                    search: 'ftfnVgYl2',
                    replace: '<%= config.chat_db_password %>',
                    flags: 'g'
                }, {
                    name: 'DB Name',
                    search: '\'ejabberd\'',
                    replace: '\'<%= config.chat_db_name %>\'',
                    flags: 'g'
                }]
            }
        },
        manifest: {
            main: {
                options: {
                    basePath: 'client',
                    timestamp: true,
                    hash: true
                },
                src: [
                    'img/*.*',
                    'css/default.cache.*.css',
                    'js/default.cache.*.js',
                    'font/*.*',
                    '*.*'
                ],
                dest: 'client/default.appcache'
            }
        },
        exec: {
            beautify: {
                cmd: [
                    'php build/beautifier.php server/php',
                    'php build/beautifier.php client/apps'
                ].join('&&')
            },
            i18n: {
                cmd: [
                    'php build/i18n.php client/js/*.js client/js/views/*.js client/js/templates/*.ejs client/apps/**/js/*.js'
                ].join('&&')
            }
        },
        lineending: {
            dist: {
                options: {
                    eol: 'lf'
                },
                files: [{
                    expand: true,
                    cwd: './',
                    src: ['server/php/shell/*.sh']
                }]
            }
        },
        zip: {
            deploy: {
                src: ['restyaboard.sh', 'ejabberd.yml', 'manifest.xml', 'sql/restyaboard_with_empty_data.sql', 'tmp/cache/', 'api_explorer/**/*.*', 'server/php/**/*.*', 'media/**/*.*', 'client/*.*', 'client/css/authorize.css', 'client/css/default.cache.*.css', 'client/js/default.cache.*.js', 'client/js/authorize.cache.js', 'client/js/workflow_templates/*.*', 'client/font/**/*.*', 'client/img/**/*.*', 'client/locales/**/*.*'],
                dest: 'restyaboard.zip'
            },
            main: {
                src: ['manifest.xml', 'api_explorer/**/*.*', 'server/php/**/*.*', 'media/**/*.*', 'client/*.*', 'client/css/authorize.css', 'client/css/default.cache.*.css', 'client/js/default.cache.*.js', 'client/js/authorize.cache.js', 'client/js/workflow_templates/*.*', 'client/font/**/*.*', 'client/img/**/*.*', 'client/locales/**/*.*', 'client/apps/**/*.*'],
                dest: 'restyaboard.zip'
            }
        },
        jasmine: {
            pivotal: {
                src: js_files,
                options: {
                    specs: [],
                    helpers: []
                }
            },
            coverage: {
                src: js_files,
                options: {
                    specs: 'client/spec/**/*.js',
                    template: require('grunt-template-jasmine-istanbul'),
                    templateOptions: {
                        report: [{
                            type: 'html',
                            options: {
                                dir: 'client/html'
                            }
                        }, {
                            type: 'text-summary'
                        }]
                    }
                }
            }
        },
        plato: {
            default: {
                files: {
                    'reports': source_js_files
                }
            },
        },
        complexity: {
            generic: {
                src: source_js_files,
                options: {
                    breakOnErrors: true,
                    jsLintXML: 'report.xml',
                    checkstyleXML: 'checkstyle.xml',
                    errorsOnly: false,
                    cyclomatic: [3, 7, 12],
                    halstead: [8, 13, 20],
                    maintainability: 100,
                    hideComplexFunctions: false,
                    broadcast: false
                }
            }
        },
        docco: {
            debug: {
                src: source_js_files,
                options: {
                    output: 'docs/'
                }
            }
        },
        watch: {
            files: ['client/js/**/*.js', 'client/js/templates/*.ejs', 'client/css/**/*.css', '!client/css/bootstrap.css', '!client/css/default.cache.css', '!client/js/templates/templates.js', '!client/js/default.cache.js'],
            tasks: ['jshint', 'less', 'jst']
        }
    });
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-eslint');
    grunt.loadNpmTasks('grunt-closure-tools');
    grunt.loadNpmTasks('grunt-phplint');
    grunt.loadNpmTasks('grunt-phpcs');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-jst');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-jsbeautifier');
    grunt.loadNpmTasks('grunt-prettify');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-filerev');
    grunt.loadNpmTasks('grunt-usemin');
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks('grunt-regex-replace');
    grunt.loadNpmTasks('grunt-manifest');
    grunt.loadNpmTasks('grunt-lineending');
    grunt.loadNpmTasks('grunt-zip');
    grunt.loadNpmTasks('grunt-contrib-jasmine');
    grunt.loadNpmTasks('grunt-plato');
    grunt.loadNpmTasks('grunt-complexity');
    grunt.loadNpmTasks('grunt-docco');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.registerTask('format', ['jsbeautifier:default', 'prettify', 'exec']);
    grunt.registerTask('pre-commit', ['jshint', 'phplint', 'jsbeautifier:pre-merge']);
    grunt.registerTask('build', 'Build task', function(env) {
        if (env == 'deploy') {
            grunt.task.run(['jshint', 'phplint', 'less', 'jst', 'concat', 'cssmin', 'uglify', 'filerev', 'usemin', 'htmlmin', 'regex-replace:deploy', 'manifest', 'lineending', 'zip:deploy']);
        } else {
            grunt.config.set('config', grunt.file.readJSON('build/' + env + '.json'));
            grunt.task.run(['jshint', 'phplint', 'less', 'jst', 'concat', 'cssmin', 'uglify', 'filerev', 'usemin', 'htmlmin', 'regex-replace:replace', 'manifest', 'lineending', 'zip:main']);
        }
    });
};
