<?php
class ActivityHandler
{
    private static $not_acceptable_diff_keys = array(
        'activities', // array type
        'checklist_items', // array type
        'is_archived',
        'is_deleted',
        'created',
        'modified',
        'is_offline',
        'uuid',
        'to_date',
        'temp_id'
    );
    private static $not_acceptable_diff_obj_types = array(
        'moved_card_checklist_item',
        'add_card_desc',
        'add_card_duedate',
        'delete_card_duedate',
        'add_background',
        'change_background',
        'change_visibility'
    );
    private static $acceptable_diff_obj_types = array(
        'add_card_desc',
        'add_card_desc',
        'edit_card_duedate',
        'add_background',
        'change_background',
        'change_visibility'
    );
    public static function getActivitiesObj($obj)
    {
        global $r_debug, $db_lnk, $authUser, $_server_domain_url;
        $obj_type = $obj['type'];
        if (!empty($obj['revisions']) && trim($obj['revisions']) !== '' && $obj_type !== 'delete_label' && $obj_type !== 'change_grid_view_configuration' && $obj_type !== 'change_list_view_configuration' && $obj_type !== 'update_label' && $obj_type !== 'delete_card_dependency') {
            $revisions = unserialize($obj['revisions']);
            $obj['revisions'] = $revisions;
            $diff = array();
            if (!empty($revisions['new_value'])) {
                foreach ($revisions['new_value'] as $key => $value) {
                    if (!in_array($key, ActivityHandler::$not_acceptable_diff_keys, true) && !in_array($obj_type, ActivityHandler::$not_acceptable_diff_obj_types, true)) {
                        $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                        $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                        $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                    }
                    if (in_array($obj_type, ActivityHandler::$acceptable_diff_obj_types, true)) {
                        $diff[] = $revisions['new_value'][$key];
                    }
                }
            } else if (!empty($revisions['old_value']) && isset($obj_type) && $obj_type == 'delete_card_comment') {
                $diff[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
            }
            if (isset($diff)) {
                $obj['difference'] = $diff;
            }
        }
        if ($obj_type === 'add_board_user') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['board_user'] = executeQuery('SELECT * FROM boards_users_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_board') {
            $obj_val_arr = array(
                $obj['board_id']
            );
            $obj['board'] = executeQuery('SELECT background_picture_url, background_pattern_url, music_content, music_name, board_visibility, organization_name, organization_id FROM simple_board_listing WHERE id = $1', $obj_val_arr);
            $obj['lists'] = array();
            $lists = pg_query_params($db_lnk, 'SELECT * FROM lists_listing WHERE board_id = $1', $obj_val_arr);
            while ($list = pg_fetch_assoc($lists)) {
                $obj['lists'][] = $list;
            }
        } else if ($obj_type === 'add_list') {
            $obj_val_arr = array(
                $obj['list_id']
            );
            $obj['list'] = executeQuery('SELECT * FROM lists_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'change_list_position') {
            $obj_val_arr = array(
                $obj['list_id']
            );
            $obj['list'] = executeQuery('SELECT position, board_id FROM lists WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_card') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $obj['card'] = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $obj_val_arr);
            if (!empty($obj['card'])) {
                if (is_plugin_enabled('r_custom_fields')) {
                    $obj['custom_fields'] = array();
                    $conditions = array(
                        $obj['card']['board_id']
                    );
                    $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields_listing WHERE board_id IS NULL or board_id = $1 ORDER BY position ASC', $conditions);
                    while ($custom_field = pg_fetch_assoc($custom_fields)) {
                        $obj['custom_fields'][] = $custom_field;
                    }
                }
            }
        } else if ($obj_type === 'move_card') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $obj['card'] = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $obj_val_arr);
            if (!empty($obj['card'])) {
                $card_attachments = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE card_id = $1 ORDER BY id DESC', $obj_val_arr);
                while ($card_attachment = pg_fetch_assoc($card_attachments)) {
                    $obj['card']['card_attachments'][] = $card_attachment;
                }
                if (is_plugin_enabled('r_custom_fields')) {
                    $obj['custom_fields'] = array();
                    $conditions = array(
                        $obj['card']['board_id']
                    );
                    $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields_listing WHERE board_id IS NULL or board_id = $1 ORDER BY position ASC', $conditions);
                    while ($custom_field = pg_fetch_assoc($custom_fields)) {
                        $obj['custom_fields'][] = $custom_field;
                    }
                }
            }
        } else if ($obj_type === 'copy_card') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['card'] = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $obj_val_arr);
            if (!empty($obj['card'])) {
                $card_attachments = pg_query_params($db_lnk, 'SELECT * FROM card_attachments WHERE card_id = $1 ORDER BY id DESC', $obj_val_arr);
                while ($card_attachment = pg_fetch_assoc($card_attachments)) {
                    $obj['card']['card_attachments'][] = $card_attachment;
                }
                if (is_plugin_enabled('r_custom_fields')) {
                    $obj['custom_fields'] = array();
                    $conditions = array(
                        $obj['card']['board_id']
                    );
                    $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields_listing WHERE board_id IS NULL or board_id = $1 ORDER BY position ASC', $conditions);
                    while ($custom_field = pg_fetch_assoc($custom_fields)) {
                        $obj['custom_fields'][] = $custom_field;
                    }
                }
            }
        } else if ($obj_type === 'add_card_checklist') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['checklist'] = executeQuery('SELECT * FROM checklists_listing WHERE id = $1', $obj_val_arr);
            if (!empty($obj['checklist'])) {
                $obj['checklist']['checklists_items'] = json_decode($obj['checklist']['checklists_items'], true);
            }
        } else if ($obj_type === 'add_card_label' || $obj_type === 'update_card_label') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE  card_id = $1 ORDER BY id ASC', $obj_val_arr);
            while ($row = pg_fetch_assoc($s_result)) {
                $obj['labels'][] = $row;
            }
        } else if ($obj_type === 'update_label') {
            $label_id = json_decode($obj['revisions']);
            $label_id = $label_id->{'id'};
            $obj_val_arr = array(
                $obj['board_id'],
                $label_id
            );
            $s_result = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE  board_id = $1 AND label_id = $2 ORDER BY id ASC', $obj_val_arr);
            while ($row = pg_fetch_assoc($s_result)) {
                $obj['labels'][] = $row;
            }
        } else if ($obj_type === 'add_card_voter') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['voter'] = executeQuery('SELECT * FROM card_voters_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_card_user') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['user'] = executeQuery('SELECT * FROM cards_users_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'update_card_checklist') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['checklist'] = executeQuery('SELECT * FROM checklists_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_checklist_item' || $obj_type === 'update_card_checklist_item' || $obj_type === 'moved_card_checklist_item') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['item'] = executeQuery('SELECT * FROM checklist_items WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_card_attachment') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['attachment'] = executeQuery('SELECT * FROM card_attachments WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'change_card_position') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $obj['card'] = executeQuery('SELECT position FROM cards_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'update_card_custom_field' || $obj_type === 'add_card_custom_field' || $obj_type === 'delete_card_custom_field') {
            if (is_plugin_enabled('r_custom_fields')) {
                $obj_val_arr = array(
                    $obj['card_id']
                );
                $card = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $obj_val_arr);
                if (!empty($card)) {
                    $obj['custom_fields'] = array();
                    $conditions = array(
                        $card['board_id']
                    );
                    $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields_listing WHERE board_id IS NULL or board_id = $1 ORDER BY position ASC', $conditions);
                    while ($custom_field = pg_fetch_assoc($custom_fields)) {
                        $obj['custom_fields'][] = $custom_field;
                    }
                }
            }
        } else if ($obj_type === 'add_board_custom_field' || $obj_type === 'delete_board_custom_field') {
            if (is_plugin_enabled('r_custom_fields')) {
                $obj['custom_fields'] = array();
                $conditions = array(
                    $obj['board_id']
                );
                $custom_fields = pg_query_params($db_lnk, 'SELECT * FROM custom_fields_listing WHERE board_id IS NULL or board_id = $1 ORDER BY position ASC', $conditions);
                while ($custom_field = pg_fetch_assoc($custom_fields)) {
                    $obj['custom_fields'][] = $custom_field;
                }
            }
        } else if ($obj_type === 'move_list') {
            $conditions = array(
                $obj['list_id']
            );
            $list = executeQuery('SELECT * FROM lists WHERE id = $1', $conditions);
            $obj['list'] = $list;
        } else if ($obj['type'] == 'add_card_dependency') {
            if (is_plugin_enabled('r_gantt_view')) {
                $val_array = array(
                    $obj['card_id']
                );
                $child_cards = pg_query_params($db_lnk, 'SELECT child_card_id FROM card_dependencies WHERE parent_card_id = $1', $val_array);
                $childcards = array();
                while ($row = pg_fetch_assoc($child_cards)) {
                    if (!empty($row)) {
                        $condition = array(
                            $row['child_card_id']
                        );
                        $childCard = executeQuery('SELECT id, created, board_id, list_id, due_date, custom_fields FROM cards where id = $1', $condition);
                        $childcards[] = $childCard;
                    }
                }
                $obj['child_cards'] = $childcards;
                $parent_cards = pg_query_params($db_lnk, 'SELECT parent_card_id FROM card_dependencies WHERE child_card_id = $1', $val_array);
                $parentcards = array();
                while ($row = pg_fetch_assoc($parent_cards)) {
                    if (!empty($row)) {
                        $condition = array(
                            $row['parent_card_id']
                        );
                        $parentCard = executeQuery('SELECT id, created, board_id, list_id, due_date, custom_fields FROM cards where id = $1', $condition);
                        if (!empty($parentCard)) {
                            $parentcards[] = $parentCard;
                        }
                    }
                }
                $obj['parent_cards'] = $parentcards;
            }
        } else if ($obj['type'] == 'add_card_duedate' || $obj['type'] == 'edit_card_duedate') {
            if (is_plugin_enabled('r_gantt_view')) {
                $val_array = array(
                    $obj['card_id']
                );
                $child_cards = pg_query_params($db_lnk, 'SELECT child_card_id FROM card_dependencies WHERE parent_card_id = $1', $val_array);
                $childcards = array();
                while ($row = pg_fetch_assoc($child_cards)) {
                    if (!empty($row)) {
                        $condition = array(
                            $row['child_card_id']
                        );
                        $childCard = executeQuery('SELECT id FROM cards where id = $1', $condition);
                        if (!empty($childCard)) {
                            $childcards[] = updateDependency($childCard);
                        }
                    }
                }
                $response = array();
                if (isset($childcards[0]) && !empty($childcards[0])) {
                    $child_cards = explode(",", $childcards[0]);
                    foreach ($child_cards as $row) {
                        if (!empty($row)) {
                            $condition = array(
                                $row
                            );
                            $childCard = executeQuery('SELECT id, created, board_id, list_id, due_date, custom_fields FROM cards where id = $1', $condition);
                            if (!empty($childCard)) {
                                $response[$childCard['id']] = $childCard;
                            }
                        }
                    }
                    $obj['child_cards'] = $response;
                }
            }
        } else if ($obj['type'] == 'convert_card') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $obj['card'] = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $obj_val_arr);
        }
        return $obj;
    }
}
